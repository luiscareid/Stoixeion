%LC2014. Feb 7
%Deteccion de estados usando conceptos de algebra lineal
%La matriz formada por la multiplicacion de los eigenvalues*eigenvectors' 
%indica el conjunto de vectores linealmente independientes que describen el
%comportamiento de la red. 
%Una limitacion es que los patrones deben aparecer varias veces
%para ser considerados como estados. Para solucionar el problema solo es
%necesario concatenar la misma matriz spikes un par de veces y aparecen
%todos los patrones que no aparecian antes
%En esta rutina se genera la grafica de transiciones de estados poniendo
%cada estado de un color diferente
%En esta version uso SVD para proyectar la matriz original en otro espacio
%ortonormal dado por los eigenvalues*eigenvectors'
%X=U*S*V'; Dado que la matriz de entrada es simetrica U=V=V'=U'
%La diferencia con usar los eigenvalues es que para SVD los valores de la
%diagonal principal siempre son positivos. Por otro lado no depende de que
%la matriz original Rasterbin sea no singular.

% edos_svd=floor(edos_size_cut*size(Rasterbin,1)); %numero maximo de estados
% calculado como porcentaje del total de celulas. Si cada celula representa
% un estado entonces el analisis no tiene sentido
% Otra propiedad importante es que X'X=VSV' como X'X es conceptualmente
% igual al producto punto U=V

edos_vec=size(S_indexp,2);
rj0_svd=S_indexp;
[U_svd,S_svd,V_svd]=svd(rj0_svd);
Ut_X=abs(S_svd*V_svd'); %Proyecto mi matriz original sobre SV'
S_svd_sig=S_svd;
edos_size_cut=10; %Para determinar el numero de edos a partir de plot(sum(S_svd))

S_svd_cut=S_svd_sig(edos_size_cut,edos_size_cut); %maximo valor de S calculado 
S_svd_sig(edos_size_cut+1:edos_vec,:)=[]; %quito los valores menores al corte en renglones
S_svd_sig(:,edos_size_cut+1:edos_vec)=[]; %quito los valores menores al corte en columnas
V_svd_tsig=V_svd';
V_svd_tsig(edos_size_cut+1:edos_vec,:)=[]; %quito los valores menores al corte en renglones
S_V_sig=abs(S_svd_sig*V_svd_tsig); %matriz reducida
Ut_X_fig=S_V_sig; %LC_26mar14 %Ut_X(1:edos_svd,:);%limito el maximo 
%numero de estados en los renglones
%Toma la parte de la matriz asociada a los vectores mas significativos para
%visualizar edos_eig_cut
%~0.15*Cells active edos

figure(3)
imagesc(Ut_X_fig); %Sirve para visualizar el valor de corte mas eficiente edos_eig_cut
edos_svd_cut=4; %Quito el background. En general despues de tomar solo los valores con 
%mayor cambio de la matriz de valores singulares estos valores son muy
%bajos, pueden ser calculados a partir de la sumatoria de los factores mas
%significativos.

%Si este es mayor hay menos edos. Mientras mas vectores diferentes haya
               %hay que bajar este valor
               %bajar este valor mientras sum(rj1_svd) tenga como maximo 1
Ut_X_tt=(Ut_X_fig>=edos_svd_cut); %Threshold
rj1_svd=sortrows(Ut_X_tt);
%para comprobar que dos vectores no pertenecen al mismo estado la suma de
%todos los vectores no debe ser mayor a 1, el max en 
% figure; plot(sum(rj1_svd))
%debe ser igual a 1. LCen14 
rep_svd=find(sum(rj1_svd)>1); %encuentra los vectores que pertenecen al mismo edo
rep_svd_ii=size(rep_svd,2);
for efsei=1:rep_svd_ii
    rj1_svd(:,rep_svd(efsei))=0; %elimina los vectores que pertenecen al mismo edo
end;

cc1_svd=find(sum(rj1_svd')>2); %Busca en el histograma los estados repetidos
                               %mas de n veces
edos_rep=size(cc1_svd,2); %Estados que se repiten mas de n veces
re_size=size(rj1_svd,1); %Estados maximos
edos_pks=rj1_svd(cc1_svd,:);
edos_pks=1*edos_pks;
edos_pks_num=zeros(size(edos_pks));
for epi=1:edos_rep %Numero estados
    edos_pks_num(epi,:)=epi*edos_pks(edos_rep-epi+1,:);
end;
 
RGB_label_svd = label2rgb(edos_pks_num, @lines, 'w', 'noshuffle');
figure(4)
imshow(RGB_label_svd,'InitialMagnification','fit')

C_edos_svd= rot90(rot90(rot90(edos_pks))); %matriz con elementosXedos
sec_Pk_frames_svd=sum(edos_pks_num);

%Para incorporarlo en Stoixeion
C_edos=C_edos_svd;
sec_Pk_edos=sec_Pk_frames_svd;

