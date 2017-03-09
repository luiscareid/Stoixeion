%Funciona bien LC2014. 
%Algoritmos intuitivos que funcionan para detectar los estados de una red
%asumiendo que los picos de sincronia en diferentes tiempos no tienen una
%variacion enorme, esto es que el numero de celulas totales involucradas en
%los picos no varie de 4 a 100 por ejemplo. En dichos casos el S_index esta
%sesgado hacia determinar que picos grandes son similares y picos cortos
%diferentes. Sin embargo la deteccion de estado sigue siendo robusta.
%Una solucion podria ser normalizar los picos a un numero maximo de
%celulas. En dichos casos los S_index no reflejan ninguna estructura
%determinada. aunque el valor promedio del S_index sea similar al promedio
%del S_index de varios experimentos.
%Una limitacion es que los patrones deben aparecer al menos un par de veces
%para ser considerados como estados. Para solucionar el problema solo es
%necesario concatenar la misma matriz spikes un par de veces y aparecen
%todos los patrones que no aparecian antes
areamin=12;%Significa una ventana de al menos 500ms en Fs 4Hz
rj0=S_indexp;

rj1=sortrows(rj0);
cc1 = bwconncomp(rj1,4);
stats1 = regionprops(cc1, 'Area');
idx1 = find([stats1.Area] > areamin); 
rj2 = ismember(labelmatrix(cc1), idx1);
rj2=rj2*1;

rj2=sortrows(rj2);
cc2 = bwconncomp(rj2,4);
stats2 = regionprops(cc2, 'Area');
idx2 = find([stats2.Area] > areamin);
rj3 = ismember(labelmatrix(cc2), idx2);
rj3=rj3*1;

rj3=sortrows(rj3);
cc3 = bwconncomp(rj3,4);
stats3=regionprops(cc3);
 
labeled = labelmatrix(cc3);
RGB_label = label2rgb(labeled, @jet, 'w', 'shuffle');
figure(3)
imagesc(rj1);
figure(4)
imagesc(rj3);

figure(5)
imshow(RGB_label,'InitialMagnification','fit')
 
 hold on
numObj = numel(stats3);
centros=zeros(numObj,2);
for k = 1 : numObj
    centros(k,1)=stats3(k).Centroid(1);
    centros(k,2)=stats3(k).Centroid(2);
    
    plot(stats3(k).Centroid(1), stats3(k).Centroid(2), 'k*');
%      text(s(k).Centroid(1)+3,s(k).Centroid(2)-3, ...
%         sprintf('%d',k ), ...
%         'Color','k');
end
hold off

figure(6)
imagesc(sortrows(rj3')');

%Para encontrar los estados a partir de los centroides LC Enero 2014.
%Todos los centroides que esten dentro de un radio X son considerados como
%pertenecientes a un estado dado.
 centros=floor(centros);
 sin=1;
 st=zeros(numObj,25); %ccX25 estados como maximo
 n=0;
 cenmin=centros(1,2); %parametros de inicio
 
 for m = 2: numObj
     if (abs(centros(m,2)-centros(m-1,2))<=5) && sum(st(:,sin))==0 %El 5 deja una ventana de 10 picos para el mismo edo
         bmax=centros(m-1,2)+5;
         bmin=centros(m-1,2)-5;
         b1=centros(:,2)<=bmax; %poner como limites los bordes de cada componente
         b2=centros(:,2)>=bmin;
         b3=and(b1,b2);
         st(:,sin)= b3;
         cenmin=centros(m,2);
     end    
     if (centros(m,2)-centros(m-1,2)<=-5 && centros(m,2)-cenmin<=-5) && m==2 %primer elemento
         bbmax=centros(m-1,2)+5;
         bbmin=centros(m-1,2)-5;
         bb1=centros(:,2)<=bbmax;
         bb2=centros(:,2)>=bbmin;
         bb3=and(bb1,bb2);
         st(:,sin)= bb3;
%          cenmin=centros(m,2);
     end    
     if (centros(m,2)-centros(m-1,2)<=-5 && centros(m,2)-cenmin<=-5)
         sin=sin+1;
         cmax=centros(m,2)+5;
         cmin=centros(m,2)-5;
         c1=centros(:,2)<=cmax;
         c2=centros(:,2)>=cmin;
         c3=and(c1,c2);
         st(:,sin)= c3;
         cenmin=centros(m,2);
     end    
 end    
  edos= sum(sum(st)>0);
 C_edos=zeros(size(Rasterbin,2), edos); %matriz con elementosXedos
 sec_edos_num=zeros(numObj, edos); %Cada columna es un edo, los elementos son el #edo
 sec_edos_bin=zeros(numObj, edos); %Cada columna es un edo, los elementos son el #cc 
 
for stin = 1:edos
    sec_edos_num(:,stin)=st(:,stin)*stin;
    sec_edos_bin(:,stin)=st(:,stin);
end
sec_Pk_edos=sum(sec_edos_num');

for stk=1:edos
    elem= find(st(:,stk)==1);
    for stelem=1: size(elem,1)
       elem_temp=elem(stelem); 
       vtin=floor(stats3(elem_temp).BoundingBox(1))+1;
       vtend=vtin+floor(stats3(elem_temp).BoundingBox(3))-1;
       C_edos(vtin:vtend,stk)=1;
    end
end    

%Excluyo la posibilidad de que dos picos formen parte del mismo edo para
%numerar el histograma LC Enero 2014. El hecho de que dos picos formen
%parte del mismo estado significa que son elementos linealmente
%independientes, en general un algoritmo de reduccion dimensional veria
%dicho pico como un estado nuevo en vez de como la sumatoria lineal de dos
%elementos que pueden aparecer por separado
for stky=1:edos-1
for stkk =stky+1:edos
    ex= find(and(C_edos(:,stkk),C_edos(:,stky))==1);

    for stkx=1: size(ex,1)     
       C_edos(ex(stkx),stky)=0; %comparar de dos en dos y solo hacer ceros la primera columna
    end
end
end
