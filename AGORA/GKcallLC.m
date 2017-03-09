%clear all
%close all
path(path,'.\FUZZCLUST')
%data set
data.X = Z(:,[1 2]);

%parameters
param.c=ii;
param.m=2;
param.e=1e-3;
param.ro=ones(1,param.c);
param.val=3;
%normalization
data=clust_normalize(data,'range');

result = GKclust(data,param);
result = validity(result,data,param);

plot(data.X(:,1),data.X(:,2),'b.',result.cluster.v(:,1),result.cluster.v(:,2),'ro');
hold on
%draw contour-map
new.X=data.X;
eval=clusteval(new,result,param);

DI=result.validity.DI;