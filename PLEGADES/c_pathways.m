function [ c_path_times ] = c_pathways( Pks_Frame,sec_Pk_edos )
%28Mar14 Para encontrar el numero de rutas diferentes en un experimento.
%times_secb tiene que ser un arreglo

[ d_sec,times_sec ] = d_assemblies( Pks_Frame,sec_Pk_edos );
times_secb=cell2mat(times_sec);
d_sec_time=cat(2,d_sec,times_secb);
d_st_1a=sortrows(d_sec_time)';
d_st_1=rot90(d_st_1a)';
N=size(d_st_1,2); %Número de rutas
j=1;
k=1;
for i=1:(N-1)
    SRRa=d_st_1(2,i);
    SRRb=d_st_1(2,i+1);
    if (SRRb==SRRa)
        if (i==(N-1))
            d_st_2(:,j)=d_st_1(:,i+1);
        end
    else
    d_st_2(:,j)=d_st_1(:,i);
    j=j+1;
        if (i==(N-1))
            d_st_2(:,j)=d_st_1(:,i+1);
        end
    end
end;
c_path_times=sortrows(d_st_2',3);

end

