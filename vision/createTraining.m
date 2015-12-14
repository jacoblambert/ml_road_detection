% Breaks up images into a training dataset

imgFolder = '../kitti/data_road/training/image_2/';
gtFolder = '../kitti/data_road/training/gt_image_2/';

tic;
numTrain = 1;
for i=0:97
    
prefix = 'uu_';
    image = strcat(prefix,num2str(i,'%06i'),'.png');
    label = strcat(prefix,'road_',num2str(i,'%06i'),'.png');
     
    img = imread(image);
    lbl = imread(label);
    
    %preprocess labelling img
    lbl = sum(lbl,3);
    lbl(lbl(:,:)==510) = 1;
    lbl(lbl(:,:)~=1) = 0;
    
    [labels,numlabels] = SLICO(img,0);
    % Store superpixel image
    uu_training(numTrain).superpixel = labels;
    
    for j=0:numlabels-1
    % Extract superpixel and pixels labels
        [I,J] = find(labels==j); % Indices row I and column J
        if ~isempty(I)
            example = [];
            vote = 0;
            for k=1:length(I)
            % example = [example, img(I(k),J(k),:)];
                try
                    vote = vote + lbl(I(k),J(k));
                catch
                    disp('Weirdly shaped labels image...')
                end
            end
        end
    % Store training example
    %    umm_superpixels = ;
    % Compute and store label
        decision = round(vote/length(I));
        uu_labels(j+1,1,numTrain) = decision ;
    end
    disp(sprintf('%s complete; %0.2d seconds elapsed',image,toc));
    disp(sprintf('this image had %d superpixels',numlabels));
    disp(sprintf('for a total of %d training examples',length(uu_labels)));
    numTrain = numTrain + 1;
end

    clearvars -except uu_training uu_labels