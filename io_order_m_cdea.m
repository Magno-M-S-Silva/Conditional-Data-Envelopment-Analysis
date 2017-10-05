
Z= %Choose your conditional variable (only works with univariate Z atm)
X= %Choose your input variables
Y= %Choose your output variables

p=size(X,2);
q=size(Y,2);
r=size(Z,2);
n=length(X);

remove_x1=zeros(n,1);
remove_Z=zeros(n,1);
for i=1:p
    remove_x1=remove_x1 | isnan(X(:,i));
end
for i=1:q
    remove_x1=remove_x1 | isnan(Y(:,i));
end
for i=1:r
    remove_x1=remove_x1 | isnan(Z(:,i));
    if i>1
        remove_Z=remove_Z & Z(:,i)==0;
    else
        remove_Z=remove_Z | Z(:,i)==0;
    end
end

remove_all=remove_x1 | remove_Z;

Z=Z(~remove_all);
X=X(~remove_all);
Y=Y(~remove_all);

n=length(X);

[BWs,kopt]=opt_bandwidth_v3_multi(Z);
BWs=BWs*(1+(n)^(-1/p+q)); 

m= %Choose the size of your resampling
bts= %Choose how many resamplings will be done

Dists=pdist(Z);
Dists=Dists';
[Dists,I]=sort(squareform(Dists),2);
fac=zeros(n,n);

for p=1:n %since the bandwidths are expanded we need to recalculate how many DMUs are inside the new bandwidth and their densities
    for q=1:n 
        if Dists(q,p)<=BWs(q)
            fac(q,p)=Dists(q,p)/BWs(q);
            fac(q,p)=normpdf(fac(q,p))/(normcdf(1)-normcdf(-1));
        end
    end
end

SK=fac*ones(n,1);
fac=fac./(SK*ones(1,n));
cum=tril(ones(n,n))*fac';
cum=[zeros(1,n);cum];

theta_dea_cond_bts=zeros(n,1);

dados=struct('Y',Y,'X',X,'cum',cum,'I',I,'m',m,'bts',bts);
dados_pool=parallel.pool.Constant(dados);

tic
parfor i=1:n
    [theta_dea_cond_bts(i),theta_sam,avg_err]=io_mDEA(dados_pool.Value.Y,dados_pool.Value.X,i,dados_pool.Value.cum,dados_pool.Value.I,dados_pool.Value.m,dados_pool.Value.bts);
end
tempo=toc;