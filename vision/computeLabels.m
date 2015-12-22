function [ labels ] = computeLabels(lbl,superpixelLabels)
% Given a binary image, compute the labels of the superpixels 

%% Reshape lbl if it is smaller than superpixelLabels
N=size(superpixelLabels,1); M=size(superpixelLabels,2);
n=size(lbl,1); m=size(lbl,2);
if (n<N || m<M)
    fprintf('superpixel img is %d-by-%d and ground truth img is %d-by-%d, reshaping!\n',N,M,n,m);
    temp = zeros(max(n,N),max(m,M)); temp(max(n,N)-n+1:end,max(m,M)-m+1:end)=lbl; lbl=temp;
end
    
%% Compute label
for i=0:max(max(superpixelLabels))
    % Extract superpixel and pixels labels
        [I,J] = find(superpixelLabels==i); % Indices row I and column J
        votes = diag(lbl(I,J));
        labels(i+1)=round(sum(votes)/length(votes));
end

%% Visualize
% superImage = zeros(n,m);
% for k=0:max(max(superpixelLabels))
%     [I,J] = find(superpixelLabels==k);
%     if labels(k+1)==1
%         for i=1:length(I)
%             superImage(I(i),J(i))=labels(k+1);
%         end
%     end
% end
% figure(1)
% imagesc(superImage);
% figure(2)
% imagesc(lbl);
        
        