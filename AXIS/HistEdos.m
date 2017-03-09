%Creado por LC.
%Grafica el histograma de la actividad global y pone encima de cada pico el
%numero del estado al que pertenece.
% 
% Modifications by Shuting Han

function [Hist_Edos] = HistEdos(Spikes,Pks_Frame,sec_Pk_Frame,pks)

Hist_Edos = sum(Spikes,1);
numT = size(Spikes,2);

figure; set(gcf,'color','w')
plot(1:numT,Hist_Edos)
xlim([1 numT])
xlabel('frame'); ylabel('spike count')
title('population activity per frame')

H=size(Pks_Frame,2);
hg=max(sum(Spikes));


for hh=1:H
    if sec_Pk_Frame(hh)>0
text(Pks_Frame(hh),sec_Pk_Frame(hh)*2.5+(hg-pks)/5,[num2str(sec_Pk_Frame(hh))],'FontSize',10)
    end
end;

hi=size(Spikes,2);
Pks_Frame_plot=zeros(hi,1);
%para hacer la grafica de transiciones en funcion del numero de frames
%reales
for hh=1:H
    if sec_Pk_Frame(hh)>0
    Pks_Frame_plot(Pks_Frame(hh))=sec_Pk_Frame(hh);
    end
end;

%Para hacer la grafica de estados en funcion del numero de frames 
figure; set(gcf,'color','w');
% plot([0 hi],[0 max(sec_Pk_Frame)+1]);
for hh = 1:H
    if sec_Pk_Frame(hh)>0
        text(Pks_Frame(hh),sec_Pk_Frame(hh),'|','FontSize',20)
    end
end
xlim([1 hi]); ylim([0.5 max(sec_Pk_Frame)+0.5])
set(gca,'ytick',1:H);
box on
xlabel('frame'); ylabel('ensemble')

end

