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

for i=1:length(v_e) %-1       % busca en cada vértice
    
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