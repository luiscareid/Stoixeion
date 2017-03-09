%Creado por Luisca Mayo09. Numera en forma ascendente una matriz de 1´s
%tomando cada columna como un elemento

function [RN]=RasNum(Rasterbin)

% Rasterbin 1 frame de resolución.

N=size(Rasterbin,2); %Número de picos

for i=1:N
    RNa=Rasterbin(:,i);
    RN(:,i)=RNa*i;
end;

