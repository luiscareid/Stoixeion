%Creado por Luisca En2014. Para hacer objetivo el proceso de
%analisis y para hacer automatica la eleccion de los estados
%Se necesita un archivo Spikes[cellsXframes] y especificar el número de celulas para
%considerar como un pico.
%En esta version se pueden escoger las celulas para considerar como
%pico. 
%Los elementos de Euclides: Stoixeion

%-------------------------------------------------%
%AXIS Primer bloque.
pks=3; %Deberia ser el numero de celulas con correlaciones significativas para un experimento dado 
[Rasterbin,Pks_Frame_Ren,Pks_Frame]=PksFrame(Spikes,pks); 
S_index=sindex(Rasterbin);
S_Ras=SRas(S_index,Rasterbin);
S_Ras_active=SRactive(S_Ras);
S_Ras_Ren=SRasRen(S_Ras);
Ras_tf_idf; %rutina para normalizar el Rasterbin basada en busquedas de palabras
S_index_ti=sindex(tf_idf_Rasterbin); %Primer momento del sindex esta relacionado con el numero de celulas de cada pico LC15en14
scut=0.5; %este quita el ruido esta relacionado directamente con el numero de celulas
%que forman parte de los picos de sincronia. 
%x_pks=150*pks/size(Spikes,1);
%scut=0.4755*exp(0.00747*x_pks)-0.4588*exp(-0.07993*x_pks);
% LC Dec 2013. Para celulas activas e inactivas: 0.22/5% 0.31/10% 0.38/15%
% 0.44/20% 0.55/30% 0.7/50% Por ejemplo scut=0.23 esta tomando como corte los
% vectores con al menos ~6% de celulas coactivas. Para una red con 100 neuronas activas
%esto significa que los picos que forman los estados al menos comparten 6
%celulas
%La funcion del scut es una exponencial de segundo orden 
%scut(porcentaje de celulas) especificar el porcentaje de celulas del total que formaran un edo

S_indexb=S_index_ti>scut; %Despues de este porcentaje de similitud las estructuras se ven mas claras. LC Dec13
S_indexb=S_indexb*1;
S_indexc=sindex(S_indexb); %Segundo momento del sindex
S_indexc=S_indexc>(0.44/1.5); %este define mejor las estructuras para cc
%es funcion del numero de picos totales, para 1000fr/350pks ~0.4 funciona
S_indexc=S_indexc*1;
%Esto significa que los vectores que pertenecen a un estado deben compartir al menos cierto porcentaje de elementos similares
%Para 100 vectores significativos (arriba del corte de pks) el valor de
%corte de (scut*1.7) 0.44 significa que al menos ~20%  del total de vectores debe ser similar. independiente de scut 
 
H_index=1-Hdist(S_indexc); %Genera estructuras definidas dependiendo de el costo que se necesita para
%convertir un elemento en otro. 
hcut=0.4; %Hay que cambiar el 70% de los elementos para convertirlo en otro edo
H_indexb=1-Hdist((H_index>hcut)*1);
S_indexp=(H_indexb>hcut)*1; %Segundo momento (Similitud de Hamilton) Define mejor las estructuras y quita el ruido

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

%Para encontrar las celulas mas significativas de cada estado LC18En14
csi_cut=0.25; %Porcentaje de corte para determinar las celulas que pesan mas 
%en cada estado. 0.25 me da ~15 celulas en el estado mas grande
Spikes_sort=Spikes;
csi_num_temp=zeros(size(Cells_edos));
for csi=1:edos
    csi_fr=find(sec_Pk_frames==csi);
    csi_hist_spk=sum(Spikes(:,Pks_Frame(csi_fr)));
    csi_hist=sum(Rasterbin(:,csi_fr)');
%     figure; imagesc(Rasterbin(:,csi_fr));
    csi_hist_norm=csi_hist/max(csi_hist);
    % figure;plot(csi_hist_norm); %Graficar para determinar csi_cut
    csix=find(csi_hist_norm>csi_cut);
    csi_num_temp(1:size(csix,2),csi)=csix';
end

csi_ren=max(sum(csi_num_temp>0));
csi_num=zeros(csi_ren,edos);
csi_num=csi_num_temp(1:csi_ren,:); %Celulas mas representativas de cada estado
[S_index_significant, sis_query]=Search_significant(csi_num,tf_idf_Rasterbin,Rasterbin);
figure (8); plot(S_index_significant');
figure (9); imagesc(sortrows(sis_query));
%     Spikes_sort=sortrows(Spikes_sort,csi_num(find(csi_num>0)));
%     figure; imagesc(Spikes_sort);

%---------------------------------
%Para buscar y graficar todos los vectores de cada estado. Con esto la
%visualizacion de los estados es mas clara. Basicamente es la
%descomposicion del S_index en 3D en sus componentes mas representativas

for siq=1:edos
    query=Rasterbin(:,Pk_edos(find(Pk_edos(:,siq)>0),siq));
    [S_index_query]=sindex_query(query,tf_idf_Rasterbin,Rasterbin);
    figure(9+siq);
    plot(S_index_query');
end


