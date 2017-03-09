%Grafica las variables desde el Workspace. LC
%Hace todas las graficas del Stoixeion exepto Dunn´s index
path(path,'.\AGORA')

clear Z
col=size(LLE_Z,2);
Z=LLE_Z(:,col-1:col);
clear centros
ii=size(Pk_edos,2);
figure(1)
FCMcallLC;

%------------------------------------------------%
ii=centros;
figure(3)
KmedoidcallLC;

fprintf(1,'----->****Use the mouse to select points****<------ \n\n\n');
figure(4)
plot(Z(:,1),Z(:,2),'+')  %grafica Z
% Activa al mouse para numerar cada punto de la nueva proyección; 
%Esc o Return para continuar
%gname()

figure(5)
pcolor(S_index)

figure(6)
pcolor(S_Ras_active)

figure(7)
pcolor(S_Ras_active_sort)

figure(8)
plot(Din_Pob)