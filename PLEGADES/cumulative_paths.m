%28Mar14 Para encontrar el numero de rutas diferentes en un experimento.
%times_secb tiene que ser un arreglo

[ d_sec,times_sec ] = d_assemblies( Pks_Frame,sec_Pk_edos );
d_sec_time=cat(2,d_sec,times_secb);
d_st_1=sortrows(d_sec_time);

N=size(d_st_1,2); %Número de rutas
j=1;
for i=1:(N-1)
    SRRa=d_st_1(:,i);
    SRRb=d_st_1(:,i+1);
    if (SRRb==SRRa)
        if (i==(N-1))
            d_st_1(:,j)=SRRa;
        end
    else
    d_st_1(:,j)=SRRa;
    j=j+1;
        if (i==(N-1))
            d_st_1(:,j)=SRRb;
        end
    end
end;