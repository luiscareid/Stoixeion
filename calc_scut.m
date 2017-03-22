function [scut] = calc_scut(data)
% calculate threshold of similarity values from shuffled data

num_shuff = 100;
p = 0.88;
dims = size(data);

% make shuffled data
data_shuff = zeros(dims(1),dims(2),num_shuff);
for n = 1:num_shuff
    data_shuff(:,:,n) = shuffle(data,'time');
end
    
% calculate similarity matrix
warning('off')
S = zeros(dims(2),dims(2),num_shuff);
for n = 1:num_shuff
%     S(:,:,n) = sindex(data_shuff(:,:,n));
    S(:,:,n) = 1-pdist2(squeeze(data_shuff(:,:,n))',squeeze(data_shuff(:,:,n))','cosine');
end
warning('on')

% determine threshold
bins = 0:0.01:1;
cd = histc(S(:),bins);
cd = cumsum(cd/sum(cd));
scut = bins(find(cd>p,1));

end