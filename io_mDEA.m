function [theta,f_per,n_f_per,avg_err]=io_mDEA(Y,X,i,cum,I,m,bts)

theta_sam=zeros(bts,1);
err=zeros(bts,1);

for t=1:bts
    sprintf('%i-th resample for DMU %i',[t,i])
    R=rand(1,m);
    [Y_bts,X_bts]=sampling(R,cum,I,Y,X,i);
    try
        [theta_sam(t),err(t)]=io_dea(Y_bts,X_bts,Y(i,:),X(i,:));
    catch Err
       % disp(Err)
        sprintf('%i-th resample for DMU %i',[t,i])
        break
    end
end
theta=mean(theta_sam);
f_per_pos=ceil((bts*0.05));
n_f_per_pos=floor((bts*0.95));
sort_theta=sort(theta_sam);
f_per=sort_theta(f_per_pos);
n_f_per=sort_theta(n_f_per_pos);
avg_err=mean(err);    