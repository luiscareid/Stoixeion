function [ S_index_query ] = sindex_query( query,tf_idf_Rasterbin,Rasterbin )
%Busca los vectores de query en el diccionario de Rasterbin
%Para buscar los que pertenecen a un estado dado 
%query=Rasterbin(:,Pk_edos(find(Pk_edos(:,edo)>0),edo));

%Normalizo query tf-idf
[sis_cti sis_pools]=size(query);
tf_query=zeros(sis_cti,sis_pools);
idf_query=zeros(sis_cti,sis_pools);
tf_idf_query=zeros(sis_cti,sis_pools);
sis_fti=size(tf_idf_Rasterbin,2);
for fti1=1:sis_pools
    for cti1=1:sis_cti
            tf_query(cti1,fti1)=query(cti1,fti1)/sum(query(:,fti1));
            if (sum(Rasterbin(cti1,:)==1))>0
            idf_query(cti1,fti1)=1+log(sis_fti/(sum(Rasterbin(cti1,:)==1)));
            end
            if (sum(Rasterbin(cti1,:)==1))==0
            idf_query(cti1,fti1)=1+log(sis_fti);
            end
            tf_idf_query(cti1,fti1)=tf_query(cti1,fti1)*idf_query(cti1,fti1);
    end

    %Sindex de query con el diccionario 
    for i=1:sis_fti
        Aa=tf_idf_query(:,fti1);
        Ab=tf_idf_Rasterbin(:,i);

        P_punto=dot(Aa,Ab);
        Magnitud=norm(Aa)*norm(Ab);
        Si=P_punto/Magnitud;
        S_index_query(fti1,i)=Si;
    end
end

end

