%LC2014. 
%Deteccion de estados usando conceptos de algebra lineal
%La matriz formada por la multiplicacion de los eigenvalues*eigenvectors 
%indica el conjunto de vectores linealmente independientes que describen el
%comportamiento de la red. 
%Una limitacion es que los patrones deben aparecer varias veces
%para ser considerados como estados. Para solucionar el problema solo es
%necesario concatenar la misma matriz spikes un par de veces y aparecen
%todos los patrones que no aparecian antes
%En esta rutina se genera la grafica de transiciones de estados poniendo
%cada estado de un color diferente
edos_size_cut=0.25; %Para determinar el maximo numero de edos
edos_eigs=floor(edos_size_cut*size(Rasterbin,1)); %numero maximo de estados
% calculado como porcentaje del total de celulas. Si cada celula representa
% un estado entonces el analisis no tiene sentido
edos_vec=size(S_indexp,2);
rj0_eig=S_indexp;
[eig_vec,eig_val]=eig(rj0_eig);
eig_vec_val=abs(eig_vec*(eig_val)); %Pongo los vectores mas significativos a la derecha
eig_vec_val_fig=eig_vec_val(:,edos_vec-edos_eigs:edos_vec)';%pongo los mas significativos en los renglones
%Toma la parte de la matriz asociada a los vectores mas significativos para
%visualizar edos_eig_cut
%~0.1*Cells active edos

figure(3)
imagesc(eig_vec_val_fig); %Sirve para visualizar el valor de corte mas eficiente edos_eig_cut
edos_eig_cut=3;%Si este es mayor hay menos edos. Mientras mas vectores diferentes haya
               %hay que bajar este valor
eig_vec_val_tt=(eig_vec_val_fig>=edos_eig_cut);
rj1_eig=sortrows(eig_vec_val_tt);
%para comprobar que dos vectores no pertenecen al mismo estado la suma de
%todos los vectores no debe ser mayor a 1, el max en 
%figure; plot(sum(rj1_eig))
%debe ser igual a 1. LCen14 
rep_eig=find(sum(rj1_eig)>3); %encuentra los vectores que se repitieron 
rep_eig_ii=size(rep_eig,2);
for efsei=1:rep_eig_ii
    rj1_eig(:,rep_eig(efsei))=0; %elimina los vectores que pertenecen al mismo edo
end;

cc1_eig=find(sum(rj1_eig')>1); %Busca en el histograma los estados repetidos
                               %al menos 2 veces
edos_rep=size(cc1_eig,2);
re_size=size(rj1_eig,1);
edos_pks=rj1_eig(re_size-edos_rep+1:re_size,:);
edos_pks=1*edos_pks;
edos_pks_num=zeros(size(edos_pks));
for epi=1:edos_rep %Numero estados
    edos_pks_num(epi,:)=epi*edos_pks(edos_rep-epi+1,:);
end;
 
RGB_label_eig = label2rgb(edos_pks_num, @lines, 'w', 'noshuffle');
figure(4)
imshow(RGB_label_eig,'InitialMagnification','fit')

C_edos_eig= rot90(rot90(rot90(edos_pks))); %matriz con elementosXedos
sec_Pk_frames_eig=sum(edos_pks_num);

%Excluyo la posibilidad de que dos picos formen parte del mismo edo para
%numerar el histograma LC Enero 2014. Como la suma de todos los eigvectores
%verticalmente tiene como maximo 1, eso me asegura que los picos no se
%repiten en dos estados. En el caso de que se repitan hacerlos cero para descartarlos.
%Buscar la implementacion en Edos_from_Sindex de la manera geometrica.
% for stky=1:edos_rep-1
% for stkk =stky+1:edos_rep-1
%     ex= find(and(C_edos_eig(:,stkk),C_edos_eig(:,stky))==1);
% 
%     for stkx=1: size(ex,1)     
%        C_edos_eig(ex(stkx),stky)=0; %comparar de dos en dos y solo hacer ceros la primera columna
%     end
% end
% end

%Para incorporarlo en Stoixeion
C_edos=C_edos_eig;
sec_Pk_edos=sec_Pk_frames_eig;

