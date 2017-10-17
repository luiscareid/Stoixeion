function [C_edos,sec_Pk_edos] = Edos_from_Sindex_svd(S_indexp,state_cut)
% 
%LC2014. Feb 7
%Deteccion de estados usando conceptos de algebra lineal
%La matriz formada por la multiplicacion de los eigenvalues*eigenvectors' 
%indica el conjunto de vectores linealmente independientes que describen el
%comportamiento de la red. 
%Una limitacion es que los patrones deben aparecer varias veces
%para ser considerados como estados. Para solucionar el problema solo es
%necesario concatenar la misma matriz spikes un par de veces y aparecen
%todos los patrones que no aparecian antes
%En esta rutina se genera la grafica de transiciones de estados poniendo
%cada estado de un color diferente
%En esta version uso SVD para proyectar la matriz original en otro espacio
%ortonormal dado por los eigenvalues*eigenvectors'
%X=U*S*V'; Dado que la matriz de entrada es simetrica U=V=V'=U'
%La diferencia con usar los eigenvalues es que para SVD los valores de la
%diagonal principal siempre son positivos. Por otro lado no depende de que
%la matriz original Rasterbin sea no singular.
% 
% Modifications by Shuting Han, 2017

p = 0.05; %significant states need to appear at least 5% of the time to be considered LCR

% do SVD on binarized similarity matrix
sz = size(S_indexp,2);
[U_svd,S_svd,V_svd] = svd(S_indexp);

% binary search factor cut
% S_rec = U_svd*S_svd*V_svd';
% fmi = min(S_rec(:));
% fma = max(S_rec(:));
fac_cut = 0.4; %(fmi+fma)/2;
dlt = 1;
while dlt > 0
    
        % restore factors
    fac_count = zeros(state_cut,1);
    for n = 1:state_cut
        fac_count(n) = sum(sum((V_svd(:,n)*V_svd(:,n)'*S_svd(n,n))>fac_cut));
    end

    edos_temp1=floor(sqrt(fac_count));
    edos_temp2=find(edos_temp1./sum(edos_temp1)>=p);
    num_state=size(edos_temp2,1);

    % find cells for each state
    svd_sig = zeros(sz,sz,num_state);
    for n = 1:num_state
        svd_sig(:,:,n) = (V_svd(:,edos_temp2(n))*V_svd(:,edos_temp2(n))'*S_svd(edos_temp2(n),edos_temp2(n)))>fac_cut;
    end

    edos_rep = size(svd_sig,3);
    edos_pks_num = zeros(edos_rep,sz);
    for epi = 1:edos_rep % number of states
        edos_pks_num(epi,sum(svd_sig(:,:,epi))>0) = 1;
    end
    % To check that two edos do not overlap: figure; plot (sum (edos_pks_num));

    if max(sum(edos_pks_num))>1
        fac_cut=fac_cut+0.01;
        dlt=1;
    else
        dlt=0;
    end

    % threshold all factors with current cutoff value
%     fac = zeros(sz,sz);
%     for ii = 1:state_cut
%         fac = fac+double((V_svd(:,ii)*V_svd(:,ii)'*S_svd(ii,ii))>fac_cut);
%     end
    
%     % check overlap, update lower and upper boundaries %sometimes
%     non-orthogonal, changed algorithm LCR 
%     if any(fac(:)>1) % cut too small, there's overlap, increase
%         fcut_old = fac_cut;
%         fac_cut = (fac_cut+fma)/2;
%         fmi = fac_cut;
%     else % cut too large, decrease
%         fcut_old = fac_cut;
%         fac_cut = (fac_cut+fmi)/2;
%         fma = fac_cut;
%     end
    
end

%fac_cut=0.85;


% fac_count = cumsum(fac_count);    %Conceptual mistake, should be
% sorted in order to avoid errors LCR
% fac_count = fac_count/fac_count(end);
% num_state = find(fac_count>p,1)-1;

% %remove values smaller than cut in rows and columns
% S_svd_sig = S_svd(1:edos_size_cut,1:edos_size_cut);
% V_svd_tsig = V_svd(:,1:edos_size_cut)';
% 
% % restore matrix with only components associated with large singular values
% svd_fac = zeros(sz,sz,edos_size_cut);
% for efsvd = 1:edos_size_cut
%     svd_fac(:,:,efsvd) = (abs(V_svd_tsig(efsvd,:)'*V_svd_tsig(efsvd,:))*S_svd_sig(efsvd,efsvd));
% end

% cut for SVD factors
% edos_svd_cut = 0.77;
% svd_fac = (svd_fac>edos_svd_cut)*1;
% rep_svd = 5; %Find the repeated more than n^2 times
% svd_sig = svd_fac(:,:,sum(sum(svd_fac,1),2)>rep_svd); 
% To verify that two vectors do not belong to the same state, the sum of
% all vectors should not be greater than 1

edos_pks_num_sort = sortrows(edos_pks_num);
edos_pks_num_sort = rot90(edos_pks_num_sort');
edos_pks_num_sort_n = zeros(size(edos_pks_num_sort));
for epii = 1:edos_rep %Numero estados
    edos_pks_num_sort_n(epii,:) = edos_pks_num_sort(epii,:)*epii;
end

% plot identified states
figure(3);
imagesc(edos_pks_num_sort_n==0);colormap(gray)
xlabel('frame'); ylabel('ensemble index'); title('ensemble activity')

edos_pks_numb = edos_pks_num';
C_edos_svd = zeros(size(edos_pks_numb));
for epix = 1:size(edos_pks_numb,1)
    C_edos_svd(epix,:) = edos_pks_numb(epix,:)*epix;
end;

C_edos = edos_pks_num_sort';
sec_Pk_edos = sum(edos_pks_num_sort_n);

end
