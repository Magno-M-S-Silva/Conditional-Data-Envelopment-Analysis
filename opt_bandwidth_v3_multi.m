function [hZ,kopt]=opt_bandwidth_v3(Z)
n=length(Z);

Dists=pdist(Z);
Dists=sort(squareform(Dists));
Dists=Dists';


k_min=max(round(n*0.05),2); %rule of thumb minimal k
k_max=min(round(n*0.25),n);
result=zeros(k_max-k_min+1,1); %function CV(k) value that will be calculated next

for k=k_min:k_max 
   %disp(k) %to keep track of the loop
   fac=(Dists)./(Dists(:,k)*ones(1,n)); %These are the (Zj-Zi)/hzi values
   fac=fac(:,2:k); % removing the distances to itself and points outside the bandwidth
   fac=normpdf(fac)/(normcdf(1)-normcdf(-1)); %applying the truncated normal kernel
   f_hat=(fac*ones(k-1,1)/(n-1))./Dists(:,k); %Summing over j different of i, dividing by n and the bandwidth size
   CV=(ones(1,n)*log(f_hat))/n; %averaging the logarithm of f_hat
   result(k-k_min+1)=CV; %saving the result for each k
end


[~,kopt]=max(result);
hZ=Dists(:,kopt);

