%A partir del S_index vectorizado compara todos los renglones para
%determinar cuales son diferentes. El numero de renglones diferentes
%constituye el numero total de estados de la red. LC Mayo 2010.

function [Edos_vector]=Nedos_b(S_index)

N=size(S_index,2); %Número de picos
S_indext=S_index>0.2; %Considera los vectores con un sobrelape del 20%
S_indext=S_indext*1;

Nedos_temp=zeros(N,N);
j=1;
it=1;
jj=2;

for i=1:N
    Nedos_temp(it,j)=i;
   
    for ii=1:N                %ii=(i+1):N solo compara a partir del siguiente
     if (i~=ii)
    Ya=S_indext(:,i);
    Yb=S_indext(:,ii);
    
    P_punto=dot(Ya,Yb);  %Determina el S_index del S_index
    Magnitud=norm(Ya)*norm(Yb);
    Si=P_punto/Magnitud;
    
    if (Si>=0.7) %Si el porcentaje de similitud entre dos vectores del S_index 
                 %es mayor al 70% considera esos vectores como
                 %pertenecientes al mismo estado
    Nedos_temp(jj,j)=ii;
    jj=jj+1;
    end
     end
    end;   
    it=1;
    jj=2;
    j=j+1;
end;

Edos_vector=Nedos_temp;
Edos_vector=sort(Edos_vector, 'descend');