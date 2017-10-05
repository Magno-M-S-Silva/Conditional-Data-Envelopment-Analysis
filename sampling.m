function [sampleY,sampleX]=sampling(R,cum,I,Y,X,i)

% R é vetor linha.

m=length(R);
n=size(cum,1);

%for k=1:m %para cada valor sorteado
   %         pos=find((cum(1:n-3,i)<R(k) & cum(2:n-2,i)>R(k))==1);
  %          Y_bts(k,:)=Y(I(i,pos+1),:);
 %           X_bts(k)=X(I(i,pos+1));
%end

[pos,~]=find(cum(1:n-3,i)*ones(1,m)<=ones(n-3,1)*R & cum(2:n-2,i)*ones(1,m)>=ones(n-3,1)*R); %find the positions of the random values

sampleY=Y(I(i,pos+1),:);
sampleX=X(I(i,pos+1),:);