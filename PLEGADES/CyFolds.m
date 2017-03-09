%Busca los (ciclos Hamiltonianos o Eulerianos) de la secuencia dada por
%sec_Pk_edos_Ren. [Cyclic_folds]=CyFolds(sec_Pk_edos_Ren)
%str_sec=int2str(sec_Pk_edos_Ren);%No pasa bien la sec para Drakontos



function [Ciclos_nums,Ciclos_H_E]=CyFolds(sec_Pk_edos_Ren)

str_sec=char(sec_Pk_edos_Ren);%Funciona pero no se ven los nums

% path(path,'.\PLEGADES\DRAKONTOS')
Cyclic_folds=drakontos(str_sec);

%a=double(ans(n,:,1)); %el n-esimo ciclo. Regresa  una cadena a nums

Ciclos_nums=double(Cyclic_folds(:,:,1));
Ciclos_H_E=Cyclic_folds(:,:,2); 

Secuencia=sec_Pk_edos_Ren;

seci=size(Ciclos_nums,2);
fprintf('Sequence:');
fprintf('%d_',Secuencia(1,:));
fprintf('\n\nCyclic Folds:\n');
fprintf('Hamiltonian or Eulerian\n\n');

for iis=1:seci
    if (Ciclos_H_E(iis)>0)
        fprintf('%s:',Ciclos_H_E(iis));
        fprintf('%d_',Ciclos_nums(iis,:));
        fprintf('\n');
    end
end;