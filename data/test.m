% test algorithms% kNN

data = trainingExamples(1:50000,:); data_targets = targets(1:50000);
testing_data = trainingExamples(end-20000:end); testing_targets = targets(end-20000:end);

% loop through columns of trainingExamples
for i=1:size(data,2)
    % find max element
    max_element = max(data(:,i));
    data(:,i) = data(:,i)./max_element;
end

[predicted_test_labels] = run_knn(5, data, data_targets, testing_data);
classification_errors = xor(testing_targets,predicted_test_labels);
classification_error_rate = sum(classification_errors)/length(test_labels)*100;

% SVM