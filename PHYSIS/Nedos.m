%A partir del S_index vectorizado compara todos los renglones para
%determinar cuales son diferentes. El numero de renglones diferentes
%constituye el numero total de estados de la red. LC Junio 2010.

function [Edos_vector]=Nedos(S_index)

N=size(S_index,2); %Número de picos
S_indext=S_index>0.3; %Considera los vectores con un sobrelape del 30%
S_indext=S_indext*1;

%El primer estado es la primera columna del S_indext binario
%Nedos_temp=zeros(N,1);
Nedos_temp=S_indext(:,1);

bi=0; %bandera para evitar la redundancia en Nedos_temp

for ii=2:N %Empieza a partir del segundo vector
      Nt=size(Nedos_temp,2); %Solo tomo el numero de estados previamente definidos
    for i=1:Nt  %(ii-1)  %Solo compara todos los vectores anteriores que ya forman 
                    %un estado especifico   
                
    Ya=Nedos_temp(:,i);
    Yb=S_indext(:,ii);
    
    P_punto=dot(Ya,Yb);  %Determina el S_index entre el vector siguiente y los 
                        %vectores que representan un estado ya definido
    
    Magnitud=norm(Ya)*norm(Yb);
    Si=P_punto/Magnitud;
    
    if (Si>=0.7) %Si el porcentaje de similitud entre dos vectores del S_index 
                 %es mayor al 70% considera esos vectores como
                 %pertenecientes al mismo estado
    Nedos_temp(:,i)=Nedos_temp(:,i)+Yb;
    Nedos_bin=Nedos_temp>0;
    Nedos_temp=Nedos_bin*1;
    bi=1;
           
    elseif (bi==0 & i==Nt)
        Nedos_temp=horzcat(Nedos_temp,Yb);
    end
    
    end;   
end;

Edos_vector=Nedos_temp;
%Edos_vector=sort(Edos_vector, 'descend');