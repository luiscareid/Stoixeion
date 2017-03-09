%Creado por LC
%Encuentra el porcentaje de celulas compartidas entre los diferentes
%estados.


function [Shared_Cells]=SharedCells(Cells_edos_active)

S=size(Cells_edos_active,2);


for ss=1:S
    for zz=(ss+1):S
        Sa=Cells_edos_active(:,ss);
        Sb=Cells_edos_active(:,zz);
        Sc=size(find(Sa==ss),1); %Elementos estado 'a'
        Sd=size(find(Sb==zz),1); %Elementos estado 'b'
        Se=Sa+Sb;
        Sf=size(find(Se==ss+zz),1); %Interseccion 'a n b'
        Shared_Cells(ss,zz)=(Sf/(Sc+Sd-Sf))*100;        
    end;
end;
