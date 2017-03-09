function [tf_idf_Rasterbin] = Ras_tf_idf(Rasterbin)
% TF-IDF normalization
% INPUT: 
%     Rasterbin: N-by-T spike matrix with only significant frames
% OUTPUT:
%     tf-idf_Rasterbin: continuous matrix after tf-idf normalization
% 
% The goal is to normalize the S_index array in such a way
% that it is only necessary to choose a threshold
% Step 1: Term frequency
% TF = number that shows each cell in a vector / total of active cells per vector
% Step 2: Inverse document freq
% IDF = 1 + loge (peaks / (number of peaks where a cell appears))
% For a rasterbin of cellsXframes, TF is cellsXframes, IDF is cellsXframes,
% TF * IDF is not multiplication of matrices but
% Rasterbin (c1, f1) = TF (c1, f1) * IDF (c1, f1)
% 
% Luis Carrillo-Reid, 2014; Shuting Han, 2017

[cti, fti]=size(Rasterbin);
tf_Rasterbin=zeros(cti,fti);
idf_Rasterbin=zeros(cti,fti);
tf_idf_Rasterbin=zeros(cti,fti);

for cti1=1:cti
    for fti1=1:fti
        tf_Rasterbin(cti1,fti1)=Rasterbin(cti1,fti1)/sum(Rasterbin(:,fti1));
        if (sum(Rasterbin(cti1,:)==1))>0
        idf_Rasterbin(cti1,fti1)=1+log(fti/(sum(Rasterbin(cti1,:)==1)));
        end
        if (sum(Rasterbin(cti1,:)==1))==0
        idf_Rasterbin(cti1,fti1)=1+log(fti);
        end
        tf_idf_Rasterbin(cti1,fti1)=tf_Rasterbin(cti1,fti1)*idf_Rasterbin(cti1,fti1);
    end
end

end