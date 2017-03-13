%Creado por Luisca En2014. Para hacer objetivo el proceso de
%analisis y para hacer automatica la eleccion de los estados
%Se necesita un archivo Spikes[cellsXframes] y especificar el número de celulas para
%considerar como un pico.
%En esta version se pueden escoger las celulas para considerar como
%pico. 
%Los elementos de Euclides: Stoixeion

%-------------------------------------------------%
%AXIS Primer bloque.
pks=3;  %Numero de neuronas para considerar como pico
[Rasterbin,Pks_Frame_Ren,Pks_Frame]=PksFrame(Spikes,pks); 
S_index=sindex(Rasterbin);
S_Ras=SRas(S_index,Rasterbin);
S_Ras_active=SRactive(S_Ras);
S_Ras_Ren=SRasRen(S_Ras);
Ras_tf_idf; %rutina para normalizar el Rasterbin basada en busquedas de palabras
S_index_ti=sindex(tf_idf_Rasterbin);
scut=0.1723; %este quita el ruido
S_indexb=S_index_ti>scut; %Despues de este porcentaje de similitud las estructuras se ven mas claras. LC Dec13
S_indexb=S_indexb*1;
S_indexc=sindex(S_indexb);
S_indexc=S_indexc>(0.44); %este define mejor las estructuras para cc
%Esto significa que los vectores que pertenecen a un estado deben compartir al menos 30% de elementos similares
S_indexc=S_indexc*1; 
% LC Dec 2013. Para celulas activas e inactivas: 0.22/5% 0.31/10% 0.38/15%
% 0.44/20% 0.55/30% 0.7/50% Por ejemplo scut=0.39 esta tomando como corte los
% vectores con menos del 15% de celulas coactivas.
H_index=1-Hdist(S_indexc);
H_indexb=1-Hdist((H_index>0.3)*1);
S_indexp=(H_indexb>0.3)*1; %Segundo momento 1-distancia de Hamilton
%Hay que cambiar el 70% de los elementos para convertirlo en otro edo 
S_Ras_Ren_active=S_indexp;
figure(1)
imagesc(S_index_ti);

figure(2)
imagesc(S_indexp)


% %--------------------------------------------------%
% %AGORA Tercer bloque.
% %But if at first the idea is not absurd, there's no hope for it...
%Encuentra los picos que hay en los estados y las celulas en los estados
Edos_from_Sindex; %Enero 2014 encuentra los estados a partir de componentes conectados indice 4. Genera C_edos
%Los centroides alineados en el mismo renglon forman estados similares

[Pk_edos,Cells_edos]=Pkedos(C_edos,Rasterbin);
Cells_edos_active=SRactive(Cells_edos);
[Shared_Cells]=SharedCells(Cells_edos_active);

%--------------------------------------------------%
%PLEGADES Quinto bloque.
% path(path,'.\PLEGADES')
%Encuentra la secuencia entre los estados
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





