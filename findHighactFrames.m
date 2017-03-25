function [data_high,pks_frame,pks] = findHighactFrames(data,pks)
% find high activity frame using a threshold determined from shuffled data
% INPUT:
%     data: N-by-T spike matrix
%     pks: significant level of frame activity; if left empty ([]), this
%         function will determine its value using shuffled data
% OUTPUT:
%     data_high: N-by-T' data matrix with only significant frames
%     pks_frame: 1-by-T' vector containing indices of significant frames
%     pks: value of the final threshold
% 
% Shuting Han, 2017
% LCR Changed to S_index distributions to determine pks. The idea is that
% after some pk value the similarity between vectors in real data will be
% significantly higher than the similarity between vectors in random data

% some parameters
num_shuff = 100;
p = 0.98; %LCR
% max_th = 50;
% pks_vec = 1:max_th; % maximum threshold 50 spikes
            % make shuffled data
dims = size(data);
data_shuff = zeros(dims(1),dims(2),num_shuff);
for n1 = 1:num_shuff
    data_shuff(:,:,n1) = shuffle(data,'time');
end
% determine threshold from shuffled data
if isempty(pks)    
    for n=3:max(sum(data))
        % find significant frames data
        pks_frame = find(sum(data,1)>=n);
        data_high = data(:,pks_frame);
        S_index= 1-pdist2(data_high',data_high','cosine');

        % calculate similarity matrix shuffled
        warning('off')
        for n2 = 1:num_shuff
               pks_frame_rnd = find(sum(data_shuff(:,:,n2))>=n);
               data_high_rnd = data_shuff(:,pks_frame_rnd);
               S_index_rnd= 1-pdist2(data_high_rnd',data_high_rnd','cosine');
                S_rnd=S_index_rnd(:); %To avoid NaN LCR
                S_nan=double(isnan(S_rnd(:)));
                S_nan_idx=find(S_nan==1);
                S_rnd(S_nan_idx)=[];
                S_index_rnd=reshape(S_rnd,[sqrt(size(S_rnd,1)) sqrt(size(S_rnd,1))]);
            if n2==1
                S_out=mean(S_index_rnd);
            else
                S1=mean(S_index_rnd);
                S_out = cat(2,S_out,S1);  
            end
        end
        warning('on')

        % determine threshold
        S_rnd_hist=max(S_out);
        bins = 0:0.02:S_rnd_hist;
        cd = histc(S_out,bins);
        cd = cumsum(cd/sum(cd));
        scut = bins(find(cd>p,1));
            if  mean(S_index(:))>scut         
                pks = n
                break;
            end
    end
    
end
        pks_frame = find(sum(data,1)>=pks);
        data_high = data(:,pks_frame);
end
