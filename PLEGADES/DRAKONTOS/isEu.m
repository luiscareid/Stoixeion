%% isEu(Matriz)
%
% Determina si la Matriz es un Ciclo Euleriano.
%
% Matriz = |a11 a12 ... a1n|           
%          |a21 a22 ... a2n|                    
%          | .   .  ...  . |                  
%          |an1 an2 ... ann| nXn         
%
% Propiedad del Ciclo Euleriano
%
%   1) La Matriz Euleriana sólo contiene 1 recorrido por el mismo camino
%
%   2) La suma de la columna i es igual a la suma del renglón i
%
%   3) La diagonal principal es igual a cero
%
%       Ejemplo, 
%
%                | 0  1  1  0|           |0  2  0  0|        |0  1  0  0|
%                | 0  0  1  0|           |0  0  1  1|        |0  0  1  1|              
%                | 1  0  0  1|           |1  0  0  0|        |1  0  0  0|                
%                | 1  0  0  0|           |1  0  0  0|        |1  0  0  0| 
%              (Matriz Euleriana)            (Matrices No Eulerianas)
%
%

%%
function ciclo=isEu(M)

%verifica si la matriz es cuadrada
if size(M,1)~=size(M,2) || length(size(M))~=2   
    error('MATALAB:isHam:InvalidArgument','Se requiere una matriz cuadrada.')
end

n_v=length(M);  % numero de vértices
ciclo=true;

if ~diag(M)
    if max(M)<2
        r=0;
        c=0;
        for i=1:n_v
            for j=1:n_v
                r=r+M(i,j);
                c=c+M(j,i);
            end
        end
        if r~=c
            ciclo=false;
        end
    else
        ciclo=false;
    end
else
    ciclo=false;
end

%if ciclo
 %  disp('Sí es un ciclo Euleriano');
%else
 %  disp('No es un ciclo Euleriano');
%end 

return