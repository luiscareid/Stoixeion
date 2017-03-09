%LC. Mayo 2010.
%A partir del Intraedos [cells X pks] determina el indice de sobrelape de
%todos los picos pertenecientes a ese mismo estado.
%Si el sobrelape entre los picos de un mismo estado es alto (>0.3)
%significa que dichos estados podrian ser considerados el mismo estado.
%El indice de diversidad esta definido como Div_index=1-sobrelape;
%El sobrelape esta definido como el numero de espigas coactivas (+ el numero
%de silencios coactivos) dividido entre el numero total de posibles
%coincidencias.
%Si algo engancha a la red el indice de sobrelape aumenta; si algo
%desengancha a la red el indice de sobrelape disminuye.
%La relacion entre el sobrelape y el numero de estados no es directa pero
%si es bastante intuitiva.

%***Originalmete el programa obtenia el indice de diversidad, sin embargo
%para fines estadisticos y retoricos es mejor expresar el indice de
%sobrelape. LC Mayo 2010.

function [Div_index]=diversity(Intraedos)

[cells,pks]=size(Intraedos);

spikesXcell=sum(Intraedos,2);
co_mask=sum(Intraedos,2)>1;
co_mask=co_mask*1;
coactive=spikesXcell'*co_mask;

zeros_matrix=Intraedos==0;
zeros_matrix=zeros_matrix*1;

zerosXcell=sum(zeros_matrix,2);
zeros_mask=sum(zeros_matrix,2)>1;
zeros_mask=zeros_mask*1;
cosilence=zerosXcell'*zeros_mask;

%Div_index=1-((coactive + cosilence)/(cells*pks));

Div_index=((coactive)/(cells*pks)); %Solo tomo las coactivas/ esto es sobrelape
