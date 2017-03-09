%clear all
%close all
% path(path,'.\AGORA\FUZZCLUST')

%the data
data.X = Z(:,[1 2]);

%parameters
param.c=ii;
param.m=2;
param.e=1e-6;
param.ro=ones(1,param.c);
%normalization
data=clust_normalize(data,'range');
param.val=3;

result = FCMclust(data,param);
result = validity(result,data,param); %modvalidity para todos los parametros

plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'ro');
hold on
%draw contour-map
new.X=data.X;
eval=clusteval(new,result,param);

DI=result.validity.DI;  %Solo DI
centros=result.cluster.v; %Son los centros de masa
%scatter(data.X(:,1),data.X(:,2),'+')
%gname()