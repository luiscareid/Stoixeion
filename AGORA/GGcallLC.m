%close all
%clear all
path(path,'.\FUZZCLUST')

%loading the data set
data.X = Z(:,[1 2]);

%parameters
param.c=3;  %Numero de estados
param.m=2;
param.e=1e-4;
param.vis=0;
param.val=3;
%normalization
data=clust_normalize(data,'range');

result = FCMclust(data,param);
param.c=result.data.f; %initializing with the results of C-means
result = GGclust(data,param); 
result = validity(result,data,param);

plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'ro');
hold on
%draw contour-map
new.X=data.X;
eval=clusteval(new,result,param);
DI=result.validity.DI;