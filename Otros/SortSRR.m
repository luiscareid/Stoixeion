%Creado por Luisca Mayo09. 

function [SSRR]=SortSRR(A)

N=size(A,2); 
j=1;
for i=1:(N-1)
    SSRR=sortrows(A,i);
end;
pcolor(SSRR)

%save Ras_Ren.dat Ras_Ren -ascii