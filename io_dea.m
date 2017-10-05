function [dea,opt_err]=io_dea(Y,X,y,x)

n=length(Y(:,1));
p=size(Y,2);
q=size(X,2);

f=[1 zeros(1,n)];

Aeq=[0 ones(1,n)];
beq=1; %VRS
lb=zeros(1,n+1);

A=[-x' X';zeros(p,1) -Y'];
b=[zeros(1,q) -y];

options=optimoptions('linprog','Display','off');
[pars,~,exitflag,~]=linprog(f,A,b,Aeq,beq,lb,[],[],options);

while exitflag==0
    iter=1;
    options=optimoptions('linprog','MaxIter', 10000*iter,'Display','off');
    [pars,~,exitflag,~]=linprog(f,A,b,Aeq,beq,lb,[],[],options);
    iter=iter*5;
    if iter>4
        break
    end
end
if exitflag<0
    while exitflag==0
    iter=1;
    options=optimoptions('linprog','Algorithm','dual-simplex','MaxIter', 10000*iter,'Display','off');
    [pars,~,exitflag,~]=linprog(f,A,b,Aeq,beq,lb,[],[],options);
    iter=iter*5;
    if iter>4
        break
    end
    end
end
if exitflag ~=1
    opt_err=1;
else
    opt_err=0;
end

if exitflag==-2
    dea=1;
end

try
    if size(pars,1)~=0 && pars(1)>1
        dea=1;
    elseif size(pars,1)~=0
        dea=pars(1);
    end
catch Err
    disp(Err)

end
end