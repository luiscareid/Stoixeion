function [ sequences_corr, sequences_lag ] = xcorr_sequences( Pools_coords, Spikes,xcs_lag )
%LC July 14, encuentra la correlacion entre todas las celulas que pertenecen 
%a todas las combinaciones entre dos estados diferentes.
%Las variables de salida son la media de la
%correlacion para cada par de estados y el tiempo maximo de la correlacion en frames
%Usar FFo_deriv para las correlaciones, si se usa FFo es claro que existen
%correlaciones espurias antes y despues del pico maximo
%El uso del archivo binario genera una grafica de correlacion similar pero
%las amplitudes son mas pequeñas
%AGORA
[xcs_sts]=size(Pools_coords);
correl_temp=zeros(1,xcs_lag*2+1);
correl_temp_total=zeros(xcs_sts(3),xcs_lag*2+1);
% xcs_total=(xcs_sts(3)^2-xcs_sts)/2;
xcs_cont=1;

for xcs_i=1:(xcs_sts(3)-1)
    for xcs_k=(xcs_i+1):xcs_sts(3)
        Pool_temp=Pools_coords(:,:,xcs_i);
        xcs_cells=size(find(Pool_temp(:,3)),1);

        Pool_temp_b=Pools_coords(:,:,xcs_k);
        xcs_cells_b=size(find(Pool_temp_b(:,3)),1);

        for xcs_ii=1:xcs_cells
            for xcs_iii=1:xcs_cells_b
                correl_i=xcorr(Spikes(Pool_temp(xcs_ii,3),:),Spikes(Pool_temp_b(xcs_iii,3),:),xcs_lag,'coeff'); %lag 20 frames
                correl_temp=correl_temp+correl_i;
            end
        end
        correl_temp=correl_temp/(xcs_cells*xcs_cells_b); %Todas las combinaciones posibles entre dos edos
        correl_temp_total(xcs_cont,:)=correl_temp;
        correl_temp=zeros(1,xcs_lag*2+1);
        xcs_cont=xcs_cont+1;
    end
end

sequences_corr=correl_temp_total;
xcs_m=mean(correl_temp_total);
sequences_lag=xcs_lag+1-find(xcs_m==max(xcs_m));
end

