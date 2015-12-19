% This script performs feature extraction over a database of images
close all; clear all; clc;
prefix = 'uu_'; % um_ umm_ uu_
nImages = 95; % 94 95 97
trainingExamples = [];
targets = [];
numExamples = 0;
tic;

for i=0:nImages % Loop over images 
    %% Fetch image in db
    image = strcat(prefix,num2str(i,'%06i'),'.png');
    label = strcat(prefix,'road_',num2str(i,'%06i'),'.png');
    img = imread(image);
    lbl = imread(label);
    
    %% Preprocess ground truth label
    lbl = sum(lbl,3); lbl(lbl(:,:)==510) = 1; lbl(lbl(:,:)~=1) = 0;
%    imagesc(lbl);
    
    %% Compute superpixels
    [superLabels, ~] = SLICO(img,0);
  
    %% Compute labels
    feat = computeFeatures(img,superLabels); % function loops over superpixel
    
    %% Compute features
    labels = computeLabels(lbl,superLabels);    % function loops over superpixels
    
    %% Store
    example = [feat.centroid, feat.rmean, feat.rvar, feat.gmean, feat.gvar,....
                feat.bmean, feat.bvar, feat.grmean, feat.grvar, feat.ggmean,...
                feat.ggvar, feat.gbmean, feat.gbvar];
    numNewExamples = length(example);
    trainingExamples = [trainingExamples; example];
    targets = [targets; labels'];
    numExamples = numExamples + numNewExamples;
    fprintf('%s complete; %0.2d seconds elapsed\n',image,toc)
    fprintf('%d new examples added for a total of %d!\n',numNewExamples,numExamples);
    fprintf('dataset is %d%% complete\n',round(i/nImages * 100));
            
end

clearvars -except trainingExamples targets