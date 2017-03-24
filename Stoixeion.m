function [Pools_coords] = Stoixeion(Spikes,Coord_active,FFo)
% Find ensembles using SVD method.
% INPUT:
%     Spikes: N-by-T binary spike matrix, where N is the number of neurons,
%         T is number of frames
%     Coord_active: N-by-2 matrix, containing coordinates of corresponding
%         neurons (for visualization purpose only)
%     FFo: N-by-T matrix, containing the calcium transients of cells. For
%         visualization purpose only; leave it empty if you don't want to
%         plot the calcium signals.
% OUTPUT:
%     Pools_coords: N-by-3-by-K matrix, where K is the number of identified
%         ensembles. In each slice of Pools_coords(:,:,k), first two
%         columns contain the [x,y] coordinates of cells in the kth
%         ensemble, and the third column contains the index.
% 
% For details about this method, see the following paper:
% Carrillo-Reid, et al. "Endogenous sequential cortical activity evoked by
% visual stimuli." Journal of Neuroscience 35.23 (2015): 8813-8828.
% 
% Luis Carrillo-Reid, 2014
% Modifications by Shuting Han, 2017
% 

%% set parameters
% significant level of spike count per frame

pks = []; % default 4, leave it empty if you want an automated threshold

% This is a threshold of coactivity. Suggested range is 0.22-0.25
% X_pks = 150 * pks / size (Spikes, 1);
% Scut = 0.4755 * exp (0.00747 * x_pks) -0.4588 * exp (-0.07993 * x_pks);
% LC Dec 2013. For active and inactive cells: 0.22 / 5% 0.31 / 10% 0.38 / 15%
% 0.44 / 20% 0.55 / 30% 0.7 / 50% For example scut = 0.23 is taking as cut
% Vectors with at least ~ 6% of coactive cells. For a network with 100 active neurons
% This means that the peaks that make up the states at least share 6 cells
% The scut function is a second-order exponential
% Scut (percentage of cells) Specify the percentage of cells in the total that form an edo
scut =[]; %0.22; % leave it empty if you want an automated threshold

% another threshold for coactivity: further removes noise
hcut = 0.28; %You have to change 70% of the elements to turn it into another state

% SVD parameters
% edos_size_cut = 20; % takes only the first SVD components for faster computation
% edos_svd_cut = 0.75; % SVD factor cut-off
% rep_svd = 20^2-1; % ? an ensemble core cell has to appear this amount of frames to be considered significant
%Encuentra los repetidos mas de n veces; n sale de plot(svd_fac_mag)LCR dic15
state_cut = round(size(Spikes,1)/4); % maximum number of states is quarter total number of cells LCR

% Percent cut to determine the cells that weigh more in each state. 
% 0.25 gives me ~ 15 cells in the largest state
% csi_cut = 0.15; 
csi_vec = 0.01:0.01:0.1;
% here I'm selecting this threshold by cross-validation - this is the range
% of the parameter that the code will test

%% find similarity structure
% find high-activity frames
[Rasterbin,Pks_Frame,pks] = findHighactFrames(Spikes,pks);

% run tf-idf - make this into a function
[tf_idf_Rasterbin] = Ras_tf_idf(Rasterbin);

% calculate cosine similarity of tf-idf matrix
% S_index_ti = sindex(tf_idf_Rasterbin);
S_index_ti = 1-pdist2(tf_idf_Rasterbin',tf_idf_Rasterbin','cosine'); % this function is faster

% threshold of noise
if isempty(scut)
    scut = calc_scut(tf_idf_Rasterbin);
end

% threshold with noise percentage, then the structure becomes clear
S_indexb = double(S_index_ti>scut);
% This means that vectors that belong to a state must share at least a 
% certain percentage of similar elements. For 100 significant vectors 
% (above the pks cut) the value of cut of (scut * 1.7) 0.44 means that at 
% least ~ 20% of the total vectors should be similar. Independent of scut.

% It generates defined structures depending on the cost that is needed to 
% convert one element to another.
H_index = 1-Hdist(S_indexb);
H_indexb = 1-Hdist((H_index>hcut)*1); %LC03Feb14
S_indexp = (H_indexb>hcut)*1; %Second Moment (Hamilton's Similarity). Defines structures better and removes noise

% visualize similarity structures before and after binarization
figure(1);clf
imagesc(S_index_ti); xlabel('frame'); ylabel('frame'); title('similarity matrix')
figure(2);clf
imagesc(S_indexp==0); colormap(gray)
xlabel('frame'); ylabel('frame'); title('binarized similarity matrix')

%% do SVD, find states and cells
% Find the peaks in the states and the cells in the states
[C_edos,sec_Pk_edos] = Edos_from_Sindex_svd(S_indexp,state_cut); %,edos_size_cut,edos_svd_cut,rep_svd);
% the returned C_edos is a binary num_sig_frame-by-num_state matrix, where
% 1s indicate the timing of corresponding state; sec_Pk_edos is a
% 1-by-num_sig_frame vector, containing numbers indicating the active state

% Edos_from_Sindex_svd; % February 2014 finds the states from the
% properties given by the decomposition of the matrix tf_idf_Rasterbin in
% SVD (single value decomposition). Basically project the original matrix
% on a space formed by orthonormal vectors and their eigenvalues. The
% conceptual advantage over Edos_from_Sindex_eig is that the input matrix
% may not be singular. Conceptually, it is simpler to explain.

[~,Cells_edos] = Pkedos(C_edos,Rasterbin);
% Cells_edos is a num_cell-by-num_state matrix; column i is a vector of 
% {0, i} where i indicates the cell is part of state i

%% find sequences
% find the sequence between states
sec_Pk_edos_act = SRactive(sec_Pk_edos');
sec_Pk_edos_act = sec_Pk_edos_act';
sec_Pk_edos_Ren = SRasRen(sec_Pk_edos_act);

%Para encontrar sec_Pk_frames dado que no todos los picos fueron asignados
%a un estado
C_edos_temp=zeros(size(C_edos));
edos=size(C_edos,2);
for sii=1:edos
    C_edos_temp(:,sii)=C_edos(:,sii)*sii;
end

% plot ensemble states
sec_Pk_frames = sum(C_edos_temp,2);

HistEdos(Spikes,Pks_Frame,sec_Pk_frames,pks); 

% print detected cycles
[Ciclos_nums,Ciclos_H_E] = CyFolds(sec_Pk_edos_Ren);

% find most significant cells for each state
% csi_num_temp: columns indicate neuron members of each state
csi_num_temp = zeros(size(Cells_edos));
figure(6); clf; set(gcf,'color','w')
N = ceil(sqrt(edos));
M = ceil(edos/N);
cc = jet(length(csi_vec));
cc = max(cc-0.3,0);
for csi=1:edos
    
    tf_idf_csi_hist=sum(tf_idf_Rasterbin(:,sec_Pk_frames==csi),2)'; %Suma las celulas de cada edo en tf_idf_Rasterbin
    tf_idf_csi_hist_norm=tf_idf_csi_hist/max(tf_idf_csi_hist); %Noramliza a 1 para tener solo un parametro de corte
    
    % cross-validate csi_cut with cosine similarity
    subplot(M,N,csi); hold on
    auc = zeros(size(csi_vec));
    for n = 1:length(csi_vec)
        core_vec = zeros(size(Rasterbin,1),1);
        core_vec(tf_idf_csi_hist_norm>csi_vec(n)) = 1;
        sim_core = 1-pdist2(Rasterbin',core_vec','cosine')';
        [xx,yy,~,auc(n)] = perfcurve(double(sec_Pk_edos==csi),sim_core,1);
        plot(xx,yy,'color',cc(n,:),'linewidth',1);
    end
    plot([0 1],[0 1],'k--')
    xlim([0 1]); ylim([0 1])
    xlabel('FPR'); ylabel('TPR'); title(['state ' num2str(csi)])
    [~,best_indx] = max(auc);
    csi_cut = csi_vec(best_indx);
    csix=find(tf_idf_csi_hist_norm>csi_cut);
    csi_num_temp(1:size(csix,2),csi)=csix';
    
end

csi_ren=max(sum(csi_num_temp>0));
csi_num=csi_num_temp(1:csi_ren,:); %Celulas mas representativas de cada estado
[S_index_significant, sis_query]=Search_significant(csi_num,tf_idf_Rasterbin,Rasterbin);
figure(7); clf; plot(S_index_significant'); xlim([1 length(Pks_Frame)]);
xlabel('frame'); ylabel('similarity'); title('ensemble similarity with each frame'); legend('show')
% figure; imagesc(sortrows(sis_query)); 
figure(8); clf; imagesc(sis_query==0); colormap(gray)
xlabel('ensembles'); ylabel('cell index'); title('ensemble cells')

%% Find the coordinates of the cells that belong to each state and
% the most representative pools
[Cells_coords,Pools_coords] = Search_edos_coords(Cells_edos,sis_query,Coord_active);

% plot cross-correlations within and between ensembles
t_lag = 200;
states_corr = xcorr_states(Pools_coords,Spikes,t_lag);
sequences_corr = xcorr_sequences(Pools_coords,Spikes,t_lag);
figure(9); clf; set(gcf,'color','w')
subplot(2,1,1);plot(-t_lag:t_lag,states_corr');
xlabel('time (frame)'); ylabel('cross-correlation');
title('cell cross-correlation within each ensemble'); legend('show')
subplot(2,1,2); plot(-t_lag:t_lag,sequences_corr');
xlabel('time (frame)'); ylabel('cross-correlation');
title('cell cross-correlation between different ensembles')

% plot ensemble component cells
cc_lr = [1 0.8 0.8]; % light red
cc_r = [1 0.2 0.2]; % red
mksz = 30;
figure(10); clf; set(gcf,'color','w')
for n = 1:edos
    subplot(M,N,n); hold on
    scatter(Coord_active(:,1),-Coord_active(:,2),mksz,'k');
    scatter(Cells_coords(:,1,n),-Cells_coords(:,2,n),mksz,cc_lr,'filled');
    scatter(Pools_coords(:,1,n),-Pools_coords(:,2,n),mksz,cc_r,'filled');
    title(['ensemble #' num2str(n)]);
    axis off equal
end

%% plot calcium transients of core cells
FFo=FFo';%FFo [frames, cells] LCR
if ~isempty(FFo) 
    figure(11); clf; set(gcf,'color','w')
    Fmi = min(FFo(:));
    Fma = max(FFo(:));
    for n = 1:edos
%         subplot(M,N,n); hold on
        subplot(1,edos,n); hold on
        core = Pools_coords(:,3,n);
        core = core(core~=0);
        cc = jet(min(length(core),64));
        cc = max(cc-0.3,0);
        for ii = 1:length(core)
            f = FFo(core(ii),:);
            f = (f-Fmi)/(Fma-Fmi);
            plot(1:size(Spikes,2),ii+f,'color',cc(ii-floor(ii/65)*64,:),...
                'linewidth',1);
        end
        xlim([1 size(Spikes,2)]); ylim([0 ii+1])
        xlabel('time (frame)'); ylabel('F'); box on
        title(['core #' num2str(n)]);
        set(gca,'ytick',1:length(core));
    end
end

end