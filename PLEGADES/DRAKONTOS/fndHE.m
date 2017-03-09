%% fndHE(Enunciado)
% 
% Regresa los Ciclos de Hamilton y Euler del Enunciado.
%
% Enunciado = "string"
%
%
%%
function HandE=fndHE(e)

e_c=getCiclo(e);    % obtiene todos los ciclos del enunciado
n_he=0;             % número de ciclos de hamilton y euler encontrados

% busca entre todos los ciclos del enunciado
for i=1:size(e_c,1)
    e_m=getM(e_c(i,:));     %matriz del enunciado actual
    
    if length(e_m)>2        %matriz mínima de 3X3
        
        if isHam(e_m) || isEu(e_m)
            
            %disp(e_c(i,:))
            %disp(e_m)
            n_he=n_he+1;
            HandE(n_he,1:length(e_c(i,:)),1)=e_c(i,:);
            if isHam(e_m)
                %disp('Ciclo Hamiltoniano (Euleriano)');
                HandE(n_he,1,2)='H'; %se distinguirá que el hamiltoniano es 0
            else
                %disp('Ciclo Euleriano');
                HandE(n_he,1,2)='E'; %se distinguirá que el eureliano es 1
            end
            
        end
       
    end
end

return