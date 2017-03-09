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