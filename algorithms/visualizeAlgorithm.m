%% visualizeAlgorithms
load('um_data.mat')
prefix = 'uu_'; % um_ umm_ uu_
nImages = 50; % 94 95 97

i=55;
image = strcat(prefix,num2str(i,'%06i'),'.png');
label = strcat(prefix,'road_',num2str(i,'%06i'),'.png');
img = imread(image);
lbl = imread(label);
   
lbl = sum(lbl,3); lbl(lbl(:,:)==510) = 1; lbl(lbl(:,:)~=1) = 0;
    
[superpixelLabels, ~] = SLICO(img,1);

feat = computeFeatures(img,superpixelLabels); % function loops over superpixel
   
labels = computeLabels(lbl,superpixelLabels);    % function loops over superpixels
    
example = [feat.centroid, feat.rmean, feat.rvar, feat.gmean, feat.gvar,....
                feat.bmean, feat.bvar, feat.grmean, feat.grvar, feat.ggmean,...
                feat.ggvar, feat.gbmean, feat.gbvar];

actual_labels = labels;
%% CLASSIFY IMAGE

% kNN
% data = trainingExamples;
% % loop through columns of trainingExamples
% for i=1:size(data,2)
%     % find max element
%     max_element = max(data(:,i));
%     data(:,i) = data(:,i)./max_element;
% end
% 
% [prediction] = run_knn(5, trainingExamples(0:floor(0.4)*end,:), targets(0:floor(0.4*end)), example);

% SVM
% load('SVM_poly_uu.mat')
% [prediction,~] = predict(SVM_poly,example);
% SVM_error = sum(abs(prediction'-labels))/length(labels);
 % IGNORE THIS
%%

%% Make pretty pictures
% Green = OK
% Red = False Positive
% Yellow = False Negative
FP = 0;
FN = 0;
img = superpixelBorder(img,superpixelLabels);
img2=img;
for j=0:max(max(superpixelLabels))
    % Extract superpixel and pixels labels
        [I,J] = find(superpixelLabels==j); % Indices row I and column J
        if prediction(j+1)==actual_labels(j+1) % correct
            for i=1:length(I)
                img2(I(i),J(i),1)=0.5*img(I(i),J(i),1);
                img2(I(i),J(i),3)=0.5*img(I(i),J(i),3);
            end
            disp('Correct!')
        elseif prediction(j+1)>actual_labels(j+1) % false positive
            for i=1:length(I)
                img2(I(i),J(i),3)=0.3*img(I(i),J(i),3);
            end
            disp('False Positive')
            FP = FP+1;
        elseif prediction(j+1)<actual_labels(j+1) % false negative
            for i=1:length(I)
                img2(I(i),J(i),2:3)=0.5*img(I(i),J(i),2:3);
            end
            disp('False Negative')
            FN = FN+1;
        end
imagesc(img2);
axis equal
axis([0 size(img2,2) 0 size(img2,1)])  
drawnow
save('color_image','img2')
end


