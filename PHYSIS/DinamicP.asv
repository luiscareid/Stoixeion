%Dinamica de Poblaciones LC

function [Din_Pob]=DinamicP(S_Ras_active)

path(path,'.\AXIS')

DPb=S_Ras_active>0; %Hace 1's todos los valores mayores a cero
DPb=DPb*1;

%DPb=transpose(DPb); %Las células son lo importante

DPc=sum(DPb);
figure
plot(DPc);

DPb_Ren=SRasRen(DPb); %Solo tomo los picos diferentes
DPb=DPb_Ren;

dpks=size(DPb,2);
for dii=1:(dpks-1)
    Dpta=DPb(:,dii);
    Dptb=DPb(:,dii+1);
    if (dii==1)
        Dptd(:,1)=Dpta;
    end
    Dptc=Dptd(:,dii)+Dptb;  %Suma el temporal
    Dptc=Dptc>0;
    Dptc=Dptc*1;
    Dptd(:,dii+1)=Dptc;
end;

DPd=sum(Dptd);
Din_Pob=DPd;


