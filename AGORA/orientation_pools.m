function [Pools_OSI, Cells_OSI] = orientation_pools(sis_query,OSI,Cells_edos)
%Indice de selectividad a la orientacion de las celulas que participan en
%cada estado y en cada pool. LC05Feb14 La idea es relacionar los stoixeion
%con las celulas que son mas selectivas. OSI es un renglon que contiene el
%indice de selectividad de cada celula.
op_cut=0.5; %Corte para determinar cuales seran las mas selectivas
[op_cells,op_edos]=size(sis_query);
Pools_OSI=zeros(op_cells,op_edos);
Cells_OSI=zeros(op_cells,op_edos);

for opii=1:op_cells
    Pools_OSI(opii,:)=sis_query(opii,:)*OSI(opii);
    Cells_OSI(opii,:)=(Cells_edos(opii,:)>0)*OSI(opii);
end;
end

