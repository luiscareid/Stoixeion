% Encuentra las secuencias en la matriz Pk_edos. LC


function [sec_Pk_edos]=secuencias(Pk_edos)

picos=size(find(Pk_edos),1);

for sii=1:picos
    [aa,ss]=find(Pk_edos==sii);
    sec_Pk_edos(sii)=ss;
end;
