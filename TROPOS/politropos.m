%Creado por Luisca Mayo09. Para hacer completamente objetivo el proceso de
%las ventanas de tiempo de cada pico y para facilitar la elección de los
%estados en el LLE. 

%SRasRen() genera una matriz nXm donde n:Número de células; m:número de
%picos tomando cada pico como los cuadros con Sindex=1 del Sindex con
%1 frame.

%Para escoger las ventanas de tiempo sólo uso los cuadrados del Sindex con
%frames = 1

function [LLE_Z,DiMatrix]=politropos(S_Ras_Ren_active,s_diff)

X=S_Ras_Ren_active;
clear Y;
%s_diff=0.10;
Na=2; %iteraciones
  D=size(X,1);
  N=size(X,2);%Numero de elementos, lo que quiero agrupar
  K=15; %vecinos %Numero de frames que representan un burst LC 2013
  d=3;  %Nueva dimension
 
fprintf(1,'-->Finding best structure match. LC\n');
Din=1;
jj=1;
ematch=0;   
for i=1:Na
[Ya,DiMatrix]=lle(X,K,d);
if (Ya~=0)
[Dist_elementos,Delta,T_prop,Deltab,T_propb]=Distancia(DiMatrix,Ya);
        Da=T_prop-Delta;
        Db=T_propb-Deltab;        
        Da=abs(Da);
        Db=abs(Db);
        Dc=Da*Db;
    if ((Delta<1)&(Din>Dc)&(Da<s_diff)&(Db<s_diff))%porcentaje de diferencia entre estructuras
        %Condicion impuesta para el triangulo por max min
        
        Y(jj,:)=Ya(1,:);
        Y(jj+1,:)=Ya(2,:);
        jj=jj+2; %Numero de dimensiones en LLE de salida
        Din=Dc;
        s_e=(1-Dc)*100;
        fprintf(1,'-->Structure similarity %2.2f: a=%2.2f b=%2.2f LC\n',s_e-1,Da,Db);        
        ematch=ematch+1;
    end
end
end;
Elem=Dist_elementos;

if (ematch==0) 
    fprintf(1,'------>No structure match.<------\n\n');
    Y=Ya;
end

% PLOT OF EMBEDDING
fprintf(1,'LLE running on %d points in %d dimensions\n',N,D);
fprintf(1,'-->Projecting in a %d dimentional plane.\n',d);
fprintf(1,'-->Solving for reconstruction weights.\n');
fprintf(1,'-->Computing embedding.\n\n');
fprintf(1,'-->The elements %d and %d must belong to the same cluster.\n',Elem(1),Elem(3));
fprintf(1,'-->The elements %d and %d must belong to different clusters.\n\n',Elem(1),Elem(2));


%Grafica los numeros para identificar la transicion entre edos
%Yb=Npeaks(Y); %Puntos que son diferentes
%Los ultimos dos del LLE son los que tienen mayor similitud
Yb=Y; %Todos los LLE que encontro
pts=size(Yb,2);
reng=size(Yb,1);
nums=[1:pts];
figure(1)
plot(Yb(reng-1,:),Yb(reng,:),'+')  %grafica los ultimos 2 de Y

% Activa al mouse para numerar cada punto de la nueva proyección; Esc para
% continuar

%fprintf(1,'----->****Use the mouse to select points****<------ \n');
%gname()

%Para guardar matrices; guarda la nueva proyección
Z=transpose(Yb);

fprintf(1,'------------->Done <------------------- LC \n\n');
LLE_Z=Z;
%save Politropos_auto.dat Z -ascii
 