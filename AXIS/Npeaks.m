%Numero de picos significativamente diferentes. LC

function [Y_Ren]=Npeaks(Y)

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