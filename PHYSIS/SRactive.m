%Creado por Luisca Mayo09. 
%SRactive() genera una matriz nXm donde 
%n:Número de células activas; 
%m:número de picos 

function [SR_active]=SRactive(A)

%S_Rasterbin=Rb*Si; %Células totalesXnúmero de picos

% Rasterbin y S_index tienen que tener 1 frame de resolución.

N=size(A,1); %Número de células totales
j=1;
for i=1:N
    Ta=A(i,:);
    
    if (sum(Ta)==0)
        
    else
    SR_active(j,:)=Ta;
    j=j+1;
    end
end;

