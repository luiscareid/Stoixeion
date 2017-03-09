%Encuentra los picos que pertenecen a cada estado tambien las celulas que
%pertenecen a cada estado
%[Pk_edos,Cells_edos]=Pkedos(C_edos,Rasterbin) LC
%C_edos=result.data.f de KmedoikcallLC
%Cada columna es un estado diferente y cada elemento es el pico que
%pertenece a ese estado
%  1    2    7
%  4    3    9
%  6    5    10
%  8    0    0
%Eran diez picos. El estado 1: [1 4 6 8]
%LC29En2014 Cuando stoixeion marca un error Pk_edos mismatch significa que
%al menos un vector pertenece a dos estados distintos.

function [Pk_edos,Cells_edos]=Pkedos(C_edos,Rasterbin)

[Pks,edos]=size(C_edos);

C_edos_Num=RasNum(C_edos);
Pksa=sum(C_edos_Num');
Pksa=Pksa';

for pp=1:edos
    Pksb=find(Pksa==pp);
    pkdim=size(Pksb,1);
    for ps=1:pkdim
        Pksc(ps,pp)=Pksb(ps);
    end;
end;

Pksd=Pksc(1,:); %Tomo la primera columna
Pkse=sort(Pksd); %La ordeno en forma ascendente de esa forma
%los edos quedan numerados de acuerdo con el orden en que aparecen

%Para ver que celulas pertenecen a cada estado
%Ras_Ren=SRasRen(Rasterbin);
Ras_Ren=Rasterbin;
Cellsa=Ras_Ren*C_edos; 
Pk_edos=zeros(size(Pksc,1), edos);

for qq=1:edos
    Pksf=Pkse(qq);
    bx=find(Pksc(1,:)==Pksf);
    Pk_edos(:,qq)=Pksc(:,bx);   %Pongo cada columna en el edo correspondiente
    Cellsb(:,qq)=Cellsa(:,bx);
%Hay un numero >0 si la celula tuvo actividad en esa columna. El numero
%de Cellsb representa las veces que esa celula dispara en los picos
%significativamente diferentes i.e. los que no estan en el mismo cuadro
%rojo del S_index con fr=1
end;

Cellsc=Cellsb>=1; %Pongo 1's en todos los elementos mayores a cero

for qq=1:edos
    Cells_edos(:,qq)=Cellsc(:,qq)*qq;  
end;
%-----------------------------------------------------------%

for iis=1:edos
    fprintf('State: %d elements \n',iis);
    fprintf('%d_',Pk_edos(:,iis));
    fprintf('\n\n');
   
end;

