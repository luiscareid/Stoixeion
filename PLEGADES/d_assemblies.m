function [ d_sec,times_sec ] = d_assemblies( Pks_Frame,sec_Pk_edos )
%LCFeb14
%Genera un arreglo de primitivos y un arreglo de tiempos para cada par
%d_sec [edoa,edob]
%time_sec [frame edoa]
d_p=find(sec_Pk_edos>0);
d_n=size(d_p,2)-1;
d_sec=zeros(d_n,2);
times_sec=zeros(d_n,1);

for dai=1:d_n
    if sec_Pk_edos(d_p(dai))~=sec_Pk_edos(d_p(dai+1))
        d_sec(dai,:)=[sec_Pk_edos(d_p(dai)),sec_Pk_edos(d_p(dai+1))];
        times_sec(dai)=Pks_Frame(d_p(dai));
    end
end;
fs=find(times_sec==0);
d_sec(fs,:)=[];
times_sec(fs)=[];
times_sec=num2cell(times_sec);
end

%sec_Pk_edos(d_p) es igual sec_Pk_edos_act pero conserva la estructura de
%los frames originales. Es posible regresar al histograma y saber
%exactamente cuando ocurrio un camino especifico

