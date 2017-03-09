%Creado por Luisca Mayo09. Para hacer completamente objetivo el proceso de
%las ventanas de tiempo de cada pico y para facilitar la elección de los
%estados en el LLE. SRasRen(S_Rasterbin)

%SRasRen() genera una matriz nXm donde n:Número de células; m:número de
%picos tomando cada pico como los cuadros con Sindex=1 del Sindex con
%1 frame.

function [SRR]=SRasRen(S_Rasterbin)

% Rasterbin y S_index tienen que tener 1 frame de resolución.

N=size(S_Rasterbin,2); %Número de picos
j=1;
for i=1:(N-1)
    SRRa=S_Rasterbin(:,i);
    SRRb=S_Rasterbin(:,i+1);
    if (SRRb==SRRa)
        if (i==(N-1))
            S_Ras_Ren(:,j)=SRRa;
        end
    else
    S_Ras_Ren(:,j)=SRRa;
    j=j+1;
        if (i==(N-1))
            S_Ras_Ren(:,j)=SRRb;
        end
    end
end;

SRR=S_Ras_Ren;
