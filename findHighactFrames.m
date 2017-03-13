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

% some parameters
num_shuff = 100;
p = 0.7;
dims = size(data);
max_th = 50;
pks_vec = 1:max_th; % maximum threshold 50 spikes

% determine threshold from shuffled data
if isempty(pks)
    
    % shuffle data by changing activity per frame while keeping per cell level
    data_shuff = zeros(dims(1),dims(2),num_shuff);
    for n = 1:num_shuff
        data_shuff(:,:,n) = shuffle(data,'time');
    end
    
    for n = 1:length(pks_vec)
        data_sig = sum(sum(data,1)>pks_vec(n));
        num_sig = sum(squeeze(sum(data_shuff,1))>pks_vec(n),1);
        bin_range = 0:1:max(num_sig);
        fsig_hist = histc(num_sig,bin_range);
        fsig_hist = cumsum(fsig_hist/sum(fsig_hist));
        if data_sig>bin_range(find(fsig_hist>p,1))
            pks = pks_vec(n);
            break;
        end
    end
    
end

% find significant frames
pks_frame = find(sum(data,1)>=pks);
data_high = data(:,pks_frame);

end