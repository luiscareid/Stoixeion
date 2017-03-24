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
num_shuff = 1;
p = 0.85;
dims = size(data);

% determine threshold from shuffled data
if isempty(pks)
   
    % make shuffled data
    data_shuff = zeros(dims(1),dims(2),num_shuff);
    for n1 = 1:num_shuff
        data_shuff(:,:,n1) = shuffle(data,'time');
    end
    
    for n=3:max(sum(data))
        % find significant frames data
        pks_frame = find(sum(data,1)>=n);
        data_high = data(:,pks_frame);
        S_index= 1-pdist2(data_high',data_high','cosine');

        % find significant frames shuffled
        pks_frame_rnd = find(sum(data_shuff,1)>=n);
        data_high_rnd = data_shuff(:,pks_frame_rnd);
        S_index_rnd= 1-pdist2(data_high_rnd',data_high_rnd','cosine');

        % determine threshold
        S_rnd_hist=max(mean(S_index_rnd));
        bins = 0:0.02:S_rnd_hist;
        cd = histc(mean(S_index_rnd),bins);
        cd = cumsum(cd/sum(cd));
        scut = bins(find(cd>p,1));
            if  mean(mean(S_index))>scut         
                pks = n;
                break;
            end
    end
    
end
        pks_frame = find(sum(data,1)>=pks);
        data_high = data(:,pks_frame);
end
