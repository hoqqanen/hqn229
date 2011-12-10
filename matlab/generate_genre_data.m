addpath('libs/liblinear-1.8/matlab'); 
Data = textscan(fopen('files/msd_genre_dataset.txt'), '%s %s %s %s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
SongCellData = cell(59600, 4);
for i = 1:4
    for j = 1:59600
        SongCellData{j, i} = Data{1,i}{j};
    end
end
genres = Data{1,1};
[unique_genres something genre_labels] = unique(genres);
MatData = zeros(59600, 30);

for i = 1:30
    MatData(:, i) = Data{1,i+4};
end
featuresandlabels = zeros(59600, 31);
featuresandlabels(:, 1:30) = MatData;
featuresandlabels(:, 31)   = genre_labels;
featuresandlabels = featuresandlabels(randperm(size(featuresandlabels,1)),:);
data = featuresandlabels(:, 1:30);
genre_labels = featuresandlabels(:, 31);


train_labels  = genre_labels(1:50000);
test_labels   = genre_labels(50001:59600);
train_data    = MatData(1:50000, :);
test_data     = MatData(50001:59600, :);

sparse_train_labels = sparse(train_labels);
sparse_test_data    = sparse(test_data);
sparse_test_labels  = sparse(test_labels);
sparse_train_data   = sparse(train_data);

svm = train(sparse_train_labels, sparse_train_data,'s -4');
[predicted_label, accuracy] = predict(sparse_test_labels', sparse_test_data, svm);