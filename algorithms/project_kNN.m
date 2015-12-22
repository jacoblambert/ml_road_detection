kNN_error = zeros(3,3);
tic
for K=5
    for CASE=1:3
        
    if CASE==1
        load('um_data.mat');
    elseif CASE==2
        load('umm_data.mat');
    else
        load('uu_data.mat');
    end
    
data = trainingExamples(1:50000,:);
clear trainingExamples

%% Normalize feature axes to 1

% loop through columns of trainingExamples
for i=1:size(data,2)
    % find max element
    max_element = max(data(:,i));
    data(:,i) = data(:,i)./max_element;
end

%% Split data into training/validation and testing

testing_fraction = 1/3.5;
testing_portion = floor(testing_fraction*size(data,1));
training_portion = size(data,1)-testing_portion;

train_data = data(1:training_portion,:);
train_labels = logical(targets(1:training_portion));

test_data = data(training_portion+1:end, :);
test_labels = logical(targets(training_portion+1: end));

% memory

% %% Visualize 2 dimensions of training data
% close all
% 
% plot_feat_dim1 = 11;
% plot_feat_dim2 = 14;
% 
% count1 = 1;
% count2 = 1;
% label1 = zeros(size(train_data,1),2);
% label2 = zeros(size(train_data,1),2);
% 
% for i = 1:length(train_labels)
%     if(train_labels(i) == 1)
%         label1(count1,1) = train_data(i,plot_feat_dim1);
%         label1(count1,2) = train_data(i,plot_feat_dim2);
%         count1 = count1+1;
%     else
%         label2(count2,1) = train_data(i,plot_feat_dim1);
%         label2(count2,2) = train_data(i,plot_feat_dim2);
%         count2 = count2+1;
%     end
% end
% 
% figure(1)
% plot(label2(:,1),label2(:,2), 'r.')
% hold on
% plot(label1(:,1), label1(:,2), 'b.')
% 
% figure(2)
% plot(label1(:,1), label1(:,2), 'b.')
% hold on
% plot(label2(:,1),label2(:,2), 'r.')

%% run K-NN

% run cross validation on 10% of all data to tune k

num_folds = 7;
valid_portion = ceil(1/num_folds*size(train_data,1));

k = K;
i = 1; % fold number

% create validation and training set
valid_data = zeros(valid_portion,size(train_data,2));
valid_labels = zeros(valid_portion,1);

new_train_data = zeros(size(train_data));
new_train_labels = zeros(size(train_data,1),1);

new_train_index = 1;
valid_data_index = 1;
valid_in_train_index = i:num_folds:size(train_data,1);

% loop through original training to segregate into training and validation
for j = 1:size(train_data,1)
    % if index matches index for validation, add into validation set
    if valid_data_index <= size(valid_in_train_index,2) && j == valid_in_train_index(valid_data_index)
        % store validation features
        valid_data(valid_data_index,:) = train_data(j,:);
        
        % store validation targets
        valid_labels(valid_data_index) = train_labels(j);
        
        % increase index
        valid_data_index = valid_data_index+1;
        
    % otherwise keep data for training
    else
        % store new training data set
        new_train_data(new_train_index,:) = train_data(j,:);
        
        % store new training targets
        new_train_labels(new_train_index) = train_labels(j);
        
        % increase index
        new_train_index = new_train_index+1;
    end
end

% cut new training data and valid data
new_train_data = new_train_data(1:new_train_index-1,:);
new_train_labels = new_train_labels(1:new_train_index-1);

valid_data = valid_data(1:valid_data_index-1,:);
valid_labels = valid_labels(1:valid_data_index-1);

toc

% run k_NN
[predicted_valid_labels] = run_knn(k, new_train_data, new_train_labels, valid_data);

% get classification error
classification_errors = xor(valid_labels,predicted_valid_labels);
classification_error_rate = sum(classification_errors)/length(valid_labels)*100;

fprintf('\nClassification Error Rate: %.2f Percent\n',classification_error_rate)
fprintf('Training Set Size: %d \n',length(new_train_labels))
fprintf('Validation Set Size: %d \n\n',length(valid_labels))

kNN_error(K,CASE) = classification_error_rate;

toc

clearvars -except K kNN_error

    end

end