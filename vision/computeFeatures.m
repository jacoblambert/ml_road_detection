function [ feat ] = computeFeatures(img, labels)

% This script computes a series of features for the superpixels on an image
% feat is a structure with fields .rhist )red color histogram
%                                 .bhist blue color histogram
%                                 .ghist green color histogram
%                                 .centroid (x,y), 
%                                 .gradient colorhist (?)

% Parameters
nBins = 256; % Number of bins for the color histograms

% Compute superpixel labels
[superpixelLabels, ~] = SLICO(img,1);

% Compute gradients
Gmag = zeros(size(img));
Gdir = Gmag;
for channel=1:3
   [Gmag(:,:,channel),Gdir(:,:,channel)] = imgradient(img(:,:,channel),'CentralDifference');
   Gmag(:,:,channel) = Gmag(:,:,channel)/max(max(Gmag(:,:,channel)));
   Gdir(:,:,channel) = Gdir(:,:,channel)/max(max(Gdir(:,:,channel)));
end

% Compute features on superpixels
for i=0:max(max(superpixelLabels))
    % Extract superpixel and pixels labels
        [I,J] = find(superpixelLabels==i); % Indices row I and column J
    % Compute Centroid
        feat.centroid(i+1,:) = centroid(I,J);
    % Extract pixel from image and gradient image
        temp = img(I,J,:);
        px = diag(temp(:,:,1)); px(:,:,2)=diag(temp(:,:,2)); px(:,:,3)=diag(temp(:,:,3));  
        temp = Gmag(I,J,:);
        Gpx = diag(temp(:,:,1)); Gpx(:,:,2)=diag(temp(:,:,2)); Gpx(:,:,3)=diag(temp(:,:,3));  
    % Compute RGBHist of pixels
        px = double(px);
        feat.rmean(i+1,:) = mean(px(:,:,1)); feat.rvar(i+1,:) = var(px(:,:,1));
        feat.bmean(i+1,:) = mean(px(:,:,2)); feat.bvar(i+1,:) = var(px(:,:,2));
        feat.gmean(i+1,:) = mean(px(:,:,3)); feat.gvar(i+1,:) = var(px(:,:,3));
    % Compute something from the Gmag/Gdir images
        Gmag = double(Gmag);
        feat.grmean(i+1,:) = mean(Gpx(:,:,1)); feat.grvar(i+1,:) = var(Gpx(:,:,1));
        feat.gbmean(i+1,:) = mean(Gpx(:,:,2)); feat.gbvar(i+1,:) = var(Gpx(:,:,2));
        feat.ggmean(i+1,:) = mean(Gpx(:,:,3)); feat.ggvar(i+1,:) = var(Gpx(:,:,3));
end
    
% Plot image with superpixels
border_img = superpixelBorder(img,superpixelLabels);
figure(1)
imagesc(border_img)
hold on
scatter(feat.centroid(:,2),feat.centroid(:,1),'g')

if nargin>1
    feat.labels = labels;
end

