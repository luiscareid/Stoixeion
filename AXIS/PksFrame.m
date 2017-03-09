%Creado por Luisca Mayo09. 
%A partir de Spikes, toma los picos con un umbral determinado y genera la
%matriz Rasterbin y el arreglo Pks_Frame que indica los frames 
%correspondientes a cada pico diferente. Pks_Frame correspondería a 
%Rasterbin_Ren

function [Rasterbin,Pks_Frame_Ren,Pks_Frame]=PksFrame(Spikes,pks)

%Spikes=transpose(Spikes);
%pks=4; %número de células para considerar como pico
N=size(Spikes,2); %Número de frames
jj=1;
for ii=1:N
    Pksa=Spikes(:,ii);
    if (sum(Pksa)>=pks)
        Rasterbin(:,jj)=Pksa;
        Pks_Frame(jj)=ii;
        jj=jj+1;
    end
end;

Nb=size(Rasterbin,2); %Número de picos
jjb=1;
for iib=1:(Nb-1)
    SRRa=Rasterbin(:,iib);
    SRRb=Rasterbin(:,iib+1);
    if (SRRb==SRRa)
        if (iib==(Nb-1))
            Pks_Frame_Ren(jjb)=Pks_Frame(iib+1);
        end
    else
    Pks_Frame_Ren(jjb)=Pks_Frame(iib);
    jjb=jjb+1;
        if (iib==(Nb-1))
            Pks_Frame_Ren(jjb)=Pks_Frame(iib+1);
        end
    end
end;
