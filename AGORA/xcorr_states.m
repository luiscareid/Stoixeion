function [ states_corr, states_lag ] = xcorr_states( Pools_coords, Spikes,xcs_lag )
%LC July 14, encuentra la correlacion entre todas las celulas que pertenecen a un estado especifico
%para todos los estados. Las variables de salida son la media de la
%correlacion para cada estado y el tiempo maximo de la correlacion en frames
%Usar FFo_deriv para las correlaciones, si se usa FFo es claro que existen
%correlaciones espurias antes y despues del pico maximo
%El uso del archivo binario genera una grafica de correlacion similar pero
%las amplitudes son mas pequeñas
%AGORA

% [cross up lo] = xcorrc(a,b,'biased',100,0.9); %Para los intervalos de
%confianza
% 
% figure;
% plot(cross); hold on;
% plot(up,'k-');
% plot(lo,'k-');


[xcs_sts]=size(Pools_coords);
correl_temp=zeros(1,xcs_lag*2+1);
correl_temp_total=zeros(xcs_sts(3),xcs_lag*2+1);

for xcs_i=1:xcs_sts(3)
    Pool_temp=Pools_coords(:,:,xcs_i);
    xcs_cells=size(find(Pool_temp(:,3)),1);
    for xcs_ii=1:(xcs_cells-1)
        for xcs_iii=(xcs_ii+1):xcs_cells
            correl_i=xcorr(Spikes(Pool_temp(xcs_ii,3),:),Spikes(Pool_temp(xcs_iii,3),:),xcs_lag,'coeff'); %lag 20 frames
            correl_temp=correl_temp+correl_i;
        end
    end
    correl_temp=correl_temp/((xcs_cells^2-xcs_cells)/2); %Parte inferior del triangulo sin la diagonal principal
    correl_temp_total(xcs_i,:)=correl_temp;
    correl_temp=zeros(1,xcs_lag*2+1);
end

states_corr=correl_temp_total;
xcs_m=mean(correl_temp_total);
states_lag=xcs_lag+1-find(xcs_m==max(xcs_m));
end

