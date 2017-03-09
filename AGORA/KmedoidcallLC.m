%close all
%clear all
% path(path,'.\AGORA\FUZZCLUST')
%the data
data.X =Z(:,[1 2]);
[N,n]=size(data.X);

%data normalization
data = clust_normalize(data,'range');
plot(data.X(:,1),data.X(:,2),'.')
hold on
%parameters given
%param.c = [.821 .7132 
 %          0.1 .5
  %         .1535 .7775]
param.c=ii;
param.vis=1;
param.val=3;

result=Kmedoid(data,param);
hold on
plot(result.cluster.v(:,1),result.cluster.v(:,2),'r.')

result = validity(result,data,param);
DI=result.validity.DI;