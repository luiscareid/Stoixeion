function [data_high,pks_frame] = findHighactFrames(data,pks)
% find high activity frame using a threshold determined from shuffled data
% INPUT:
%     data: N-by-T spike matrix
%     pks: significant level of frame activity; if left empty ([]), this
%         function will determine its value using shuffled data
% OUTPUT:
%     data_high: N-by-T' data matrix with only significant frames
%     pks_frame: 1-by-T' vector containing indices of significant frames

% some parameters
num_shuff = 100;
p = 0.9;
dims = size(data);

% determine threshold from shuffled data
if isempty(pks)
    
    % shuffle data by changing activity per frame while keeping per cell level
    data_shuff = zeros(dims(1),dims(2),num_shuff);
    for n = 1:num_shuff
        data_shuff(:,:,n) = shuffle(data,'isi');
    end

    % determine significant level
    scounts = reshape(sum(data_shuff,1),[],1);
    bin_range = 0:1:max(scounts);
    scounts_hist = histc(scounts,bin_range);
    scounts_hist = cumsum(scounts_hist/sum(scounts_hist));
    pks = bin_range(ceil(find(scounts_hist>=p,1)));

end

% find significant frames
pks_frame = find(sum(data,1)>=pks);
data_high = data(:,pks_frame);

end