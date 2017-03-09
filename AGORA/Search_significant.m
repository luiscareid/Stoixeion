function [ S_index_significant, sis_query ] = Search_significant(csi_num,tf_idf_Rasterbin,Rasterbin)
%LC En14 A partir del diccionario de vectores tf-idf 
%calcula el indice de similitud basado en el angulo entre las celulas
%clave y cada vector. csi_num es una matriz [celulas edo] que contiene las celulas mas
%representativas de cada estado. tf_idf_Rasterbin es una matrix [cells
%picos] que esta normalizada. sis_query son los vectores que quiero buscar.
%sis_query representa las celulas mas significativas de cada edo.

sis_edos=size(csi_num,2);
sis_query=zeros(size(tf_idf_Rasterbin,1),sis_edos);
%Genero un vector query para buscarlo en el diccionario el vector contiene
%las celulas mas representativas de cada estado
for sis_i=1:sis_edos
    sis_query(csi_num(find(csi_num(:,sis_i)>0),sis_i),sis_i)=1; 
end

%Normalizo query tf-idf
[sis_cti]=size(sis_query,1);
tf_query=zeros(sis_cti,sis_edos);
idf_query=zeros(sis_cti,sis_edos);
tf_idf_query=zeros(sis_cti,sis_edos);
sis_fti=size(tf_idf_Rasterbin,2);
for fti1=1:sis_edos
    for cti1=1:sis_cti
            tf_query(cti1,fti1)=sis_query(cti1,fti1)/sum(sis_query(:,fti1));
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
        S_index_significant(fti1,i)=Si;
    end
end

end
