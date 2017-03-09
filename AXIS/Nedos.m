%A partir del S_index vectorizado compara todos los renglones para
%determinar cuales son diferentes. El numero de renglones diferentes
%constituye el numero total de estados de la red.

function [Edos_vector]=Nedos(S_index)

N=size(Y,2); %Número de picos
j=1;
for i=1:(N-1)
    Ya=Y(:,i);
    Yb=Y(:,i+1);
    
    Yab=Ya-Yb;
    Yab=abs(Yab);
    
    if (sum(Yab)<=0.001) %Porcentaje de similitud
        if (i==(N-1))
            Y_Ren(:,j)=Ya;
        end
    else
    Y_Ren(:,j)=Ya;
    j=j+1;
        if (i==(N-1))
            Y_Ren(:,j)=Yb;
        end
    end
end;