%Encuentra los elementos con mayor y menor distancia. LC
%Con ello se preserva la estructura en la proyección de LLE.
%Busca los elementos F y G que tengan la mayor distancia
%Despues busca el elemento mas cercano a F


function [DE,Delta,T_Prop,Deltab,T_Propb]=Distancia(Dist,Y) 
%Elementos del triangulo, delta y proporcion del triang 

A=max(Dist);  %Los elementos mas lejanos F y G
[B,F]=max(A);
C=Dist(:,F);
[D,G]=max(C);

%El elemento mas cercano a F es H
%con un intervalo de diferencia del intdif=20%

intdif=0.2*D; %D es el valor maximo

[I,indice]=sort(C);
In=size(I,1);
jd=0;
for id=1:In
    Ia=I(id);
    if (Ia>intdif)
        jd=jd+1;
    end
end;
e=In-jd+1;
Vmin=I(e);  %Este es el valor minimo
H=indice(e);
L=(Dist(G,H)); %Este es el valor entre G y H
%Para la distancia máxima entre puntos
xa=Y(1,F)-Y(1,G); 
ya=Y(2,F)-Y(2,G);
Da=[xa,ya];
Dist_max=norm(Da);

xb=Y(1,F)-Y(1,H);
yb=Y(2,F)-Y(2,H);
Db=[xb,yb];
Dist_min=norm(Db);

xc=Y(1,G)-Y(1,H);
yc=Y(2,G)-Y(2,H);
Dc=[xc,yc];
Dist_triang=norm(Dc);

DE=[F,G,H];
T_Prop=L/D;
T_Propb=Vmin/D;

if ((Dist_max>Dist_triang)&(Dist_triang>Dist_min))
    Delta=Dist_triang/Dist_max;
    Deltab=Dist_min/Dist_max;
else
    Delta=2;
    Deltab=2;
end
