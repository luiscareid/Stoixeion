%% drakontos(Enunciado)
% 
% Regresa los Ciclos de Hamilton y Euler del Enunciado.
%
% Enunciado = "string"
%
%
%%
function HandE=drakontos(e)

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

%% getCiclo(Enunciado)
%
% Regresa los ciclos del Enunciado.
%
% Enunciado = "string"
%
%
%%
function c=getCiclo(e)

if ~ischar(e)
    error('MATALAB:getCiclo:InvalidArgument','Se requiere sólo una cadena.')
end

n_c=0;  % número de ciclos
v_e=fndVer(e);   % vértices del enunciado

for i=1:length(v_e) %-1 error LC febrero 2010      % busca en cada vértice
    %al dejar el -1 no busca los ciclos que empiezan con el ultimo elemento
    %hallado en fndVer
    lim=strfind(e,v_e(i));  % límites de palabra
    
    if length(lim)>1
        for j=1:length(lim)-1 % busca todas las palabras con un vértice
            
            for k=j:length(lim)-1 % busca en toda las palabras ciclos
                w=e(lim(j):lim(k+1));   % palabra
                n_c=n_c+1;
                c(n_c,1:length(w))=w;   % matriz de ciclos
            end
            
        end
    end
    
end

return

%% fndVer(Palabra)
%
% Regresa una cadena con los vértices encontrados en la palabra.
% 
% Palabra = string
% 
% NOTA: Se consideran vértices cada símbolo diferente.
%       Ejemplo, Palabra = "ab12c#d@c"
%                en este caso el camino que sigue es:
%                a -> b -> 1 -> 2 -> c -> # -> d -> @ -> c

%%
function v=fndVer(word)

if size(word,1)>1 || ~ischar(word)
    error('MATALAB:fndVer:InvalidArgument','Se requiere sólo una cadena.')
end

n_e=length(word); %número de elementos
n_v=1;            %número de vértices

v(1)=word(1);

for i=2:n_e
    
    nuevo=true;
    
    for j=1:n_v
        if v(j)==word(i)
            nuevo=false;
            break
        end
    end
    
    if nuevo
        n_v=n_v+1;
        v(n_v)=word(i);
    end
    
end

return

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