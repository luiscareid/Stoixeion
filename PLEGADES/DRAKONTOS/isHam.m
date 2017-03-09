%% isHam(Matriz)
%
% Determina si la Matriz es un Ciclo Hamiltoniano.
%
% Matriz = |a11 a12 ... a1n|           
%          |a21 a22 ... a2n|                    
%          | .   .  ...  . |                  
%          |an1 an2 ... ann| nXn         
%
% Propiedad del Ciclo Hamiltoniano
%
%   1) La Matriz Hamiltoniana elevada a la n potencia es igual a la matriz identidad:
%
%       Matriz^n = I                Excepciones:
%                                               |1 0 ... 0|     |0 ... 0 1|
%       n, es el número de vértices             |0 1 ... 0|     |0 ... 1 0|
%                                               |. . ... .|     |. ... . .|
%                                               |0 0 ... 1|     |1 ... 0 0|
%                                               (Identidad)     (Espejo
%                                                                Identidad)
%          

%%
function ciclo=isHam(M)

%verifica si la matriz es cuadrada
if size(M,1)~=size(M,2) || length(size(M))~=2   
    error('MATALAB:isHam:InvalidArgument','Se requiere una matriz cuadrada.')
end

n_v=length(M);  % numero de vértices
I=eye(n_v);     % matriz identidad de grado n_v
ciclo=false;
M=M&M;          % Convierte a la matriz en numeros booleanos
    
if M==I
    disp('Es una matriz Identidad.'); 
elseif M^2==I
    disp('Es una matriz "Espejo de Identidad"');
elseif M^n_v==I
    ciclo=true;
end

%if ciclo
 %  disp('Sí es un ciclo Hamiltoniano');
%else
 %  disp('No es un ciclo Hamiltoniano');
%end 

return