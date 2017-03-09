%Para hacer el clustering automatico. LC
%Genera una grafica con el DIindex para todos los edos de los diferentes
%algoritmos.

function [C_edos]=clusterLC(LLE_Z,edos_max)

Z=LLE_Z;
col=size(Z,2);
Zb(:,1)=Z(:,col-1);
Zb(:,2)=Z(:,col);
Z=Zb;

%edos_max=10; %El numero de elementos diferentes es el tope para el maximo
clear DIs
clear meanDI
for ii=2:edos_max
    clf;
    figure(1)
    FCMcallLC;
    DIs(ii)=DI;   
end;

% DIs=-DIs; %el primer valle del DI Limita a 3 como el minimo numero de
% edos
figure(2) 
plot(DIs)

%----------------------------------------------%
dr=diff(DIs);  %El primer pico en FCM es el mejor numero de edos
dri=find(dr>=0);
dri=dri+1;
iid=size(dri,2);
jjx=1;
for iix=1:iid-1    %Para buscar los picos
    Pa=DIs(dri(iix));
    Pb=DIs(dri(iix)+1);
    %Pba=Pb-Pa;
    if (Pb<=Pa)
        Pksd(jjx)=dri(iix);
        jjx=jjx+1;
    end
end;

primpk=min(Pksd);


fprintf(1,'\n-------->First peak at %d states <--------\n\n',primpk);
%---------------------------------------------%

%path(path,'.\Clustering')
%edos_max=10;
%itera=50;

%clear DIs
%clear meanDI
%for ii=2:edos_max
%    for jj=1:itera
%        KmedoidcallLC;
%        DIs(jj,ii-1)=DI;
%    end;
%    meanDI(ii-1)=mean(DIs(:,ii-1));
%end;

%figure 
%plot(meanDI)

%------------------------------------------------%
clear centros
ii=primpk;
figure(1)
clf;
FCMcallLC;

%------------------------------------------------%
ii=centros;
figure(3)
KmedoidcallLC;

%-----------------------------------------------%
fprintf(1,'----->****Use the mouse to select points****<------ \n\n\n');
figure(4)
plot(Z(:,1),Z(:,2),'+')  %grafica Z
% Activa al mouse para numerar cada punto de la nueva proyección; 
%Esc o Return para continuar
gname()
%-----------------------------------------------%

%Encuentra los estados
C_edos=result.data.f;





