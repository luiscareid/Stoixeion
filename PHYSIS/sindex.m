%Sindex. LC

function [Y]=sindex(A)

N=size(A,2); %Número de picos

for i=1:N
    for j=i:N
    Aa=A(:,i);
    Ab=A(:,j);
    
    P_punto=dot(Aa,Ab);
    Magnitud=norm(Aa)*norm(Ab);
    Si=P_punto/Magnitud;
    Y(i,j)=Si;
    Y(j,i)=Si;
    end
end;