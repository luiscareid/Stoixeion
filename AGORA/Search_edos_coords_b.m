function [ Cells_coords, Pools_coords ] = Search_edos_coords( Cells_edos, sis_query, Coordactive )
%Encuentra las coordenadas de las celulas pertenecientes a cada estado y
%las coordenadas de los grupos base. Cells_coords son las coordenadas de
%cada estado [x,y,edo] Pools_coords [x,y,edo] Cells_edos: celulas de cada
%edo; sis_query: celulas representativas
%Coordactive y Cells_edos deben tener el mismo numero de celulas LCEn2014

[sec_cells, sec_edos]=size(Cells_edos);
Cells_coords=zeros(sec_cells,2,sec_edos);
Pools_coords=zeros(sec_cells,2,sec_edos);
for seci=1:sec_edos
Cells_coords_temp=find(Cells_edos(:,seci)>0);
csize_temp=size(Cells_coords_temp,1);
Cells_coords(1:csize_temp,:,seci)=Coordactive(Cells_coords_temp,:);
Pools_coords_temp=find(sis_query(:,seci)>0);
psize_temp=size(Pools_coords_temp,1);
Pools_coords(1:psize_temp,:,seci)=Coordactive(Pools_coords_temp,:);
end;

end

