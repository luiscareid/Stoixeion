%Creado por Luisca Mayo09. Para hacer completamente objetivo el proceso de
%analisis y para facilitar la elección de los
%estados en el LLE. 
%Se necesita el Rasterbin con fr=1 en el Workspace. LC
%Se necesita un archivo Spikes[cellsXframes] y especificar el número de celulas para
%considerar como un pico.

%Proceso de automatización LC
%En esta version se pueden escoger las celulas para considerar como
%pico. 
%Uso Spikes_trail en lugar de Spikes para facilitar la visualizacion de los
%estados y los elementos que lo forman. LC Enero 10. 
%Los elementos de Euclides


%-------------------------------------------------%
%AXIS Primer bloque.
% path(path,'.\AXIS')

pks=5;  %Numero de neuronas para considerar como pico
%Spikes=Spikes'; %Spikes debe tener orden [cells,frames]
[Rasterbin,Pks_Frame_Ren,Pks_Frame]=PksFrame(Spikes,pks); %Spikes_trail en lugar de Spikes
S_index=sindex(Rasterbin);
S_Ras=SRas(S_index,Rasterbin);

% S_Ras=Rasterbin;  %Rasterbin entra al LLE

S_Ras_active=SRactive(S_Ras);
S_Ras_Ren=SRasRen(S_Ras);
% S_Ras_Ren_active=SRactive(S_Ras_Ren); %Esto va al LLE
%Las mas rojas indican que esas celulas casi siempre disparan juntas
%este procedimiento mejora la deteccion de estados al asignar a cada celula
%la historia de la red. SRas indica que alguna vez una celula tuvo
%actividad con otra. LC. Febrero 2010. 
%Ayuda a discriminar cuando hay sobrelape entre dos estados.
%  Rasterbin=S_Ras_Ren_active;
%   S_Ras_Ren_active=Rasterbin;  %Rasterbin entra al LLE
%Mayo 10, Esta fue la unica manera en la cual la simulacion de 'n'
%ensambles neuronales fue correctamente detectada por el LLE y el
%clustering. En lugar de las distancias maximas tomar como criterios para
%los grupos los vectores que tengan los indices de similitud mayores dentro
%de un radio 'x'.
scut=0.32;
S_indexb=S_index>scut; %Despues de este porcentaje de similitud las estructuras se ven mas claras. LC Dec13
S_indexb=S_indexb*1;
S_indexc=sindex(S_indexb);
S_indexc=S_indexc>0.595; %Esto significa que los vectores que pertenecen a un estado deben compartir al menos 30% de elementos similares
S_indexc=S_indexc*1; 
% LC Dec 2013. Para celulas activas e inactivas: 0.22/5% 0.31/10% 0.38/15%
% 0.44/20% 0.55/30% 0.7/50% Por ejemplo scut=0.39 esta tomando como corte los
% vectores con menos del 15% de celulas coactivas.
[S_indexr, sp]=corrcoef(S_indexc);
S_indexr=S_indexr>0.05; 
S_indexr=S_indexr*1;
sr=size(S_indexr,1);
[spi,spj]=find(sp<0.0001);%Encuentra las correlaciones significativas basado en una distribucion normal
S_indexp=zeros(sr,sr);

 for jj=1:size(spi)
      if S_indexr(spi(jj),spj(jj))>0.05
          S_indexp(spi(jj),spj(jj))=1;
      end    
 end;
   
S_indexp=S_indexp+eye(sr,sr);
S_Ras_Ren_active=S_indexp;

figure(1)
pcolor(S_index);

% %--------------------------------------------------%
% %TROPOS Segundo bloque.
% % path(path,'.\TROPOS')
% s_diff=0.15;    %Porcentaje de diferencia entre estructuras
% 
% [LLE_Z,DiMatrix]=politropos(S_Ras_Ren_active,s_diff);
% 
% %--------------------------------------------------%
% %AGORA Tercer bloque.
% % path(path,'.\AGORA')
% 
% edos_max=15;   %En general pensar en mas edos para redes tan pequenhias es absurdo.
% %But if at first the idea is not absurd, there's no hope for it...
% % El numero maximo son los puntos encontrados en la grafica del segundo
% % bloque. LC
% 
% [C_edos]=clusterLC(LLE_Z,edos_max);
% 
% % path(path,'.\AXIS')

%Encuentra los picos que hay en los estados y las celulas en los estados
Edos_from_Sindex; %Enero 2014 encuentra los estados a partir de componentes conectados indice 4. Genera C_edos


[Pk_edos,Cells_edos]=Pkedos(C_edos,Rasterbin);
Cells_edos_active=SRactive(Cells_edos);
[Shared_Cells]=SharedCells(Cells_edos_active);

%--------------------------------------------------%
%PLEGADES Quinto bloque.
% path(path,'.\PLEGADES')

%Encuentra la secuencia entre los estados
% sec_Pk_frames=secuencias(Pk_edos); %sec_Pk_edos viene ahora de
% Edos_from_Sindex LC enero 2014
%Quita los numeros adyacentes repetidos
% path(path,'.\AXIS')
sec_Pk_edos_act=SRactive(sec_Pk_edos');
sec_Pk_edos_act=sec_Pk_edos_act';
sec_Pk_edos_Ren=SRasRen(sec_Pk_edos_act);

%Para encontrar sec_Pk_frames dado que no todos los picos fueron asignados
%a un estado
C_edos_temp=zeros(size(C_edos));
for sii=1:edos
    C_edos_temp(:,sii)=C_edos(:,sii)*sii;
end;

sec_Pk_frames=sum(C_edos_temp');

Hist_Edos=HistEdos(Spikes,Pks_Frame,sec_Pk_frames,pks); 


% path(path,'.\PLEGADES')
[Ciclos_nums,Ciclos_H_E]=CyFolds(sec_Pk_edos_Ren);





