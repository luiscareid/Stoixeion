function result=Kmedoid(data,param);

c = param.c;
X=data.X;

[N,n]=size(X);

%initialization
if max(size(param.c))==1,
    c = param.c;
    
    if ((N-c)>=c)
    index=randperm(N-c); %LC para eliminar el error
    else
        index=randperm(N-1);
    end
    vind=index(1:c);
        
    v=X(vind,:);
    v = v + 1e-10;
    v0=X(vind+1,:);
    v0 = v0 - 1e-10;
else
    v = param.c;    
    c = size(param.c,1);
    
    if ((N-c)>=c)
    index=randperm(N-c); %LC para eliminar el error
    else
        index=randperm(N-1);
    end
    
    vind=index(1:c);
    
    v0=X(vind,:);v0 = v0 + 1e-10;
end   
iter=0;  
while prod(max(abs(v - v0))),
      v0 = v;
     iter =iter+1;
      %mozgatás
        %Calculating the distances
         for i = 1:c
            dist(:,i) = sum([(X - repmat(v(i,:),N,1)).^2],2);
         end
        %Assigning clusters
      [m,label] = min(dist');
      distout=sqrt(dist);
      
      %Calculating cluster centers
      for i = 1:c
         index=find(label == i);
         if ~isempty(index)  
             vtemp = mean(X(index,:));
                          
             aerr=1; %el valor original era 1
             
             Xnerr=size(X,2);
             Reperr=size(repmat(vtemp,N,aerr),2);
             if (Xnerr~=Reperr)
                 aerr=Xnerr;
             end
             
             temp = sum([(X - repmat(vtemp,N,aerr)).^2],2);
             inx=find(temp==min(temp));
             inx=min(inx); %if there are many points with the minimum distance
             v(i,:)=X(inx,:);
         else 
           vierr=round(rand*N-1);
           vierr=norm(vierr);
             v(i,:)=X(vierr+1,:);
         end   
         index=find(label == i);
         f0(index,i)=1;
     end
     J(iter) = sum(sum(f0.*dist));           %calculate objective function  

%            %mozgatás
%         %Calculating the distances
%          for i = 1:c
%             dist(:,i) = sum([(X - repmat(v(i,:),N,1)).^2]')';
%          end
%         %Assigning clusters
%       [m,label] = min(dist');
    
      if param.vis
       clf
       hold on
       colors={'ro' 'bo' 'go' 'yo' 'mo' 'co' 'ko' 'r*' 'g*' 'b*' 'y*' 'm*' 'c*' 'k*' 'rs' 'gs' 'bs' 'ys' 'ms' 'cs' 'ks'};
       for i=1:c
           index = find(label == i);
           if ~isempty(index)  
            dat=X(index,:);
            plot(dat(:,1),dat(:,2),colors{i})
           end
       end    
       plot(v(:,1),v(:,2),'r.')
       hold on

       %tri=delaunay(v(:,1),v(:,2));
       %triplot(tri,v(:,1),v(:,2))
       hold off
       pause(0.001)
   end  
    
end


%results
result.cluster.v = v;
result.data.d = distout;
   %calculate the partition matrix      
f0=zeros(N,c);
   for i=1:c
     index=find(label == i);
     f0(index,i)=1;
   end       
result.data.f=f0;
result.iter = iter;
result.cost = J;