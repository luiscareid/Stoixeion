%% getM(Ciclo)
%
% Obtiene la matriz de un ciclo
%
% Ciclo = string 
%
% NOTA: el ciclo debe terminar en el vértice donde comienza.
%
% Ejemplo,
% Ciclo="abcabcdabaa"
%
%                  1  2  3  4
%
% Matriz =   1   | 1  1  2  0|           
%            2   | 1  0  2  0|                    
%            3   | 1  0  0  1|                  
%            4   | 1  0  0  0|          
%
% NOTA: el comienzo del ciclo se da en Matriz(1,2)
%

%%
function M=getM(c)

if size(c,1)>1 || ~ischar(c) 
    error('MATALAB:fndVer:InvalidArgument','Se requiere que el ciclo sea una cadena.')
end
                      
fin=strfind(c,0); % encuentra el final de la palabra. Ejemplo 'abcd sd'
                                                    % limita hasta 'abcd'
if fin
    lim=fin(1)-1;
    c=c(1:lim);
else
    lim=length(c);
end

v_c=fndVer(c);  % vértices del ciclo

if c(1)~=c(lim)
    error('MATALAB:fndVer:InvalidArgument','Se requiere un ciclo.')
end

M=zeros(length(v_c),length(v_c)); % matriz del ciclo

% coloca los caminos que hay entre vértices en la matriz
for i=1:lim-1    
    x=strfind(v_c,c(i));
    y=strfind(v_c,c(i+1));
    M(x,y)=M(x,y)+1;
end

return