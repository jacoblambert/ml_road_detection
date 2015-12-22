% This script tests an SVM with different settings
 
%% mix up data
% origExamples = trainingExamples;
% origTargets = targets;
% switcharoo = randperm(length(targets));
% trainingExamples = origExamples(switcharoo,:);
% targets = origTargets(switcharoo);

SVM_error = zeros(1,3);
error_index=1;
tic;


%% Split data into training/validation and testing
for frac=0.4

    for dataset=1:3
        if dataset==1
            load('um_data.mat')
        elseif dataset==2
            load('umm_data.mat')
        else
            load('uu_data.mat')
        end
        N=floor(frac*length(targets)); % 1:N training
        M=floor((3*frac/7)*length(targets)); % end-M:end validation
        % M+1:end testing
    
        %% Train various SVM models
%         SVM_linear = fitcsvm(trainingExamples(1:N,:),targets(1:N),'KernelFunction','linear','Standardize',true); 
%         disp('Linear SVM Training Complete');
%         
%         SVM_rbf = fitcsvm(trainingExamples(1:N,:),targets(1:N),'KernelFunction','rbf','Standardize',true); 
%         disp('Gaussian SVM Training Complete');
%         
        SVM_poly = fitcsvm(trainingExamples(1:N,:),targets(1:N),'KernelFunction','polynomial','PolynomialOrder',3,'Standardize',true); 
        disp('Polynomial (3) SVM Training Complete');
        
%         SVM_poly4 = fitcsvm(trainingExamples(1:N,:),targets2(1:N),'KernelFunction','polynomial','PolynomialOrder',3,'Standardize',true); 
%         disp('Polynomial (4) SVM Training Complete');
        
%         SVM_sigmoid = fitcsvm(trainingExamples(1:N,:),targets(1:N),'KernelFunction','sigmoid','Standardize',true); 
%         disp('Sigmoid SVM Training Complete');
%         
        %fprintf('All training complete for %i iteration. Testing %d%% complete.\n',round(error_index),round(error_index*100/14));
        fprintf('%d minutes elapsed\n',round(toc/60));
        %% Validate
%         [label_linear,~] = predict(SVM_linear,trainingExamples(end-M:end,:));
%         SVM_error(error_index,dataset,1) = sum(abs(label_linear-targets(end-M:end)))/length(targets(end-M:end));
%         fprintf('%d%% error for linear SVM\n',round(100*SVM_error(error_index,dataset,1)));
%         
%         [label_rbf,~] = predict(SVM_rbf,trainingExamples(end-M:end,:));
%         SVM_error(error_index,dataset,2) = sum(abs(label_rbf-targets(end-M:end)))/length(targets(end-M:end));
%         fprintf('%d%% error for rbf SVM\n',round(100*SVM_error(error_index,dataset,2)))
%         
        [label_poly,~] = predict(SVM_poly,trainingExamples(end-M:end,:));
        SVM_error(1,dataset) = sum(abs(label_poly-targets(end-M:end)))/length(targets(end-M:end));
        %fprintf('%d%% error for polynomial (3) SVM\n',round(100*SVM_error(error_index,dataset,3)))
        
%         [label_poly4,~] = predict(SVM_poly4,trainingExamples(end-M:end,:));
%         SVM_error(error_index,dataset,4) = sum(abs(label_poly4-targets(end-M:end)))/length(targets(end-M:end));
%         fprintf('%d%% error for polynomial (4) SVM\n',round(100*SVM_error(error_index,dataset,4)))
        
%         [label_sigmoid,~] = predict(SVM_sigmoid,trainingExamples(end-M:end,:));
%         SVM_error(error_index,dataset,5) = sum(abs(label_sigmoid-targets(end-M:end)))/length(targets(end-M:end));
%         fprintf('%d%% error for sigmoid SVM\n',round(100*SVM_error(error_index,dataset,5)))
%         save('svm_error','SVM_error')
%         clearvars -except SVM_error M N frac dataset error_index;
    end
    
end
