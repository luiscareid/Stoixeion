function [ Cells_coords, Pools_coords ] = Search_edos_coords( Cells_edos, sis_query, Coordactive )
%Encuentra las coordenadas de las celulas pertenecientes a cada estado y
%las coordenadas de los grupos base. Cells_coords son las coordenadas de
%cada estado [x,y,edo] Pools_coords [x,y,edo] Cells_edos: celulas de cada
%edo; sis_query: celulas representativas
%Coordactive y Cells_edos deben tener el mismo numero de celulas LCEn2014

[sec_cells, sec_edos]=size(Cells_edos);
Cells_coords=zeros(sec_cells,3,sec_edos); %LC Jun14 cambio 2 por 3 para incluir #cells
Pools_coords=zeros(sec_cells,3,sec_edos);
search_cell_id=[1:sec_cells]'; %Cells id
for seci=1:sec_edos
Cells_coords_temp=find(Cells_edos(:,seci)>0);
csize_temp=size(Cells_coords_temp,1);
Cells_coords(1:csize_temp,:,seci)=cat(2,Coordactive(Cells_coords_temp,:),Cells_coords_temp);
Pools_coords_temp=find(sis_query(:,seci)>0);
psize_temp=size(Pools_coords_temp,1);
Pools_coords(1:psize_temp,:,seci)=cat(2,Coordactive(Pools_coords_temp,:),Pools_coords_temp);
end;

end

