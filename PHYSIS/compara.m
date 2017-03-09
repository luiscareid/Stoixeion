%LC Mayo 2010.
%A partir del S_index toma cada renglon para comparar todos los picos que
%tengan alguna similitud entre ellos. (>20%)
%Finalmente determina el indice de sobrelape (promedio) de todos los picos
%que comparten celulas.

function [Div_index_mean]=compara(S_index,Rasterbin)

[cells,pks]=size(Rasterbin);

for n=1:pks
    jj=1;
    vt=S_index(:,n)>0.2; %vectores con una similitud mayor al 20%
    vt=vt*1;
    n_vt=sum(vt); %numero de vectores con similitud por cada renglon
    
    Intraedos=zeros(cells,n_vt);
    for ii=1:pks
        if vt(ii)>0
            Intraedos(:,jj)=Rasterbin(:,ii);
            jj=jj+1;
        end    
    end;
    
    Intraedos_active=SRactive(Intraedos);
    Div_index(n)=diversity(Intraedos_active); %solo tomo los renglones activos
    %solo tomo los renglones donde no hay puros ceros, es decir una vez
    %determinados los vectores que pertenecen a cada grupo solo considera a
    %las celulas activas
end;
Div_index_mean=Div_index;
%Div_index_mean=mean(Div_index);
