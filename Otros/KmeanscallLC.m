%close all
%clear all
path(path,'.\FUZZCLUST')
%the data
data.X = Z(:,[1 2]);
[N,n]=size(data.X);

%data normalization
data = clust_normalize(data,'range');
plot(data.X(:,1),data.X(:,2),'.')
hold on
%parameters given
%param.c = [0.51 0.91
 %          0.14 0.79
  %         0.6 0.17
   %        0.05 0.25]
param.c=4;
param.vis=1;
param.val=3;

%result=kmeans(data,param);
result=kmeans(data,param);
hold on
plot(result.cluster.v(:,1),result.cluster.v(:,2),'ro')

%nums=[1:39];
%gname(nums)

result = validity(result,data,param);
DI=result.validity.DI;