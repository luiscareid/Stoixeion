function [Y]=sindex(A)
% Calculate similarity of tf-idf normalized matrix
% INPUT:
%     A: N-by-T tf-idf normalized matrix
% OUTPUT:
%     Y: N-by-N similarity matrix
% 
% Luis Carrillo-Reid, 2014; Shuting Han, 2017

N = size(A,2); %Número de picos
Y = zeros(N,N);

for i=1:N
    for j=i:N
        
        Aa = A(:,i);
        Ab = A(:,j);
        
        % this is the cosine similarity
        P_punto = dot(Aa,Ab);
        Magnitud = norm(Aa)*norm(Ab);
        Si = P_punto/Magnitud;
        Y(i,j) = Si;
        Y(j,i) = Si;
        
    end
end

end