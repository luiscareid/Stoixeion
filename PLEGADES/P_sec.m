function [ P_transition ] = P_sec( sec_Pk_edos )
%Calcula la probabilidad de ir de un estado a otro dada una secuencia
%especifica. Genera una matriz [edosXedos] con las probabilidades de ir de
%un estado a otro incluyendo los estados recurrentes

p_edos=max(sec_Pk_edos);
trans=size(sec_Pk_edos,2);
trans_edos=zeros(p_edos,trans);
b_temp=cat(2,sec_Pk_edos(2:trans),0);
a_temp=b_temp-sec_Pk_edos;
P_transition=zeros(p_edos,p_edos);


for pi=1:p_edos
    p_temp=find(sec_Pk_edos==pi);
    z_temp=size(p_temp,2);
    trans_edos(pi,1:z_temp)=p_temp;
    p_temp2=a_temp(p_temp)+pi;
    for pii=1:p_edos
        if a_temp(trans)==-pi
        P_transition(pi,pii)=sum(p_temp2==pii)/(sum(p_temp>0)-1); %Para evitar el ultimo
        else
            P_transition(pi,pii)=sum(p_temp2==pii)/sum(p_temp>0);
        end
    end
end

