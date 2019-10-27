% load data
path_data='/home/fabian/universitaet/paper_boston19/datasets/';
name_data='dataset_1024_1000_snr_0_20.mat';
l=load([path_data name_data]);
data=l.data;
label=l.label_data;

% split data
[perm_training,perm_validation,perm_test]=split2(label);

training_data=data(:,:,:,perm_training);
training_label=label(perm_training);
test_data=data(:,:,:,perm_test);
test_label=label(perm_test);
validation_data=data(:,:,:,perm_validation);
validation_label=label(perm_validation);

size_sample=numel(training_data(1,:,1,1));
n_modulation_types=numel(unique(training_label));

poolSize=[1 2];
filterSize=[1 3];
% initial setup architecture
net=[
    imageInputLayer([1 size_sample 2], 'Normalization', 'none', 'Name', 'Input Layer')
    
    convolution2dLayer(filterSize,8, 'Padding', 'same', 'Name', 'CNN1')
    batchNormalizationLayer('Name', 'BN1')
    reluLayer('Name', 'ReLU1')
    maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool1')
    
    convolution2dLayer(filterSize,16, 'Padding', 'same', 'Name', 'CNN2')
    batchNormalizationLayer('Name', 'BN2')
    reluLayer('Name', 'ReLU2')
    maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool2')
    
    convolution2dLayer(filterSize,32, 'Padding', 'same', 'Name', 'CNN3')
    batchNormalizationLayer('Name', 'BN3')
    reluLayer('Name', 'ReLU3')
    maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool3')
    
    convolution2dLayer(filterSize,64, 'Padding', 'same', 'Name', 'CNN4')
    batchNormalizationLayer('Name', 'BN4')
    reluLayer('Name', 'ReLU4')
    maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool4')
    
    convolution2dLayer(filterSize,128, 'Padding', 'same', 'Name', 'CNN5')
    batchNormalizationLayer('Name', 'BN5')
    reluLayer('Name', 'ReLU5')
    maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool5')
    
    convolution2dLayer(filterSize,ceil(size_sample/8), 'Padding', 'same', 'Name', 'CNN6')
    batchNormalizationLayer('Name', 'BN6')
    reluLayer('Name', 'ReLU6')
    
    averagePooling2dLayer([1 ceil(size_sample/32)], 'Name', 'AP1')
    
    fullyConnectedLayer(8, 'Name', 'FC1')
    
    softmaxLayer('Name', 'SoftMax')
    
    classificationLayer('Name', 'Output')];


if parallel.gpu.GPUDevice.isAvailable
    env='gpu';
else
    env='cpu';
end

% options
minibatchsize=64;
options = trainingOptions('sgdm', ...
'InitialLearnRate',2e-2, ...
'MaxEpochs',12, ...
'Shuffle','every-epoch', ...
'MiniBatchSize',minibatchsize,...
'ValidationFrequency',numel(training_label)/minibatchsize, ...
'ValidationData',{validation_data,validation_label},...
'LearnRateSchedule', 'piecewise', ...
'LearnRateDropPeriod', 6, ...
'LearnRateDropFactor', 0.1,...
'Verbose',1,...
'ExecutionEnvironment',env);

% train network or load network
trained_network=trainNetwork(training_data,training_label',net,options);

% save trained net
path_save='/home/fabian/universitaet/paper_boston19/networks/';
name_save=['ref' name_data(8:end)];
save([path_save name_save],'trained_network');
% save(name_save,'trained_network');

% test
prediction=classify(trained_network,test_data);
accuracy=sum(test_label==prediction)/numel(test_label)

% plots
figure;
cm=confusionchart(test_label,prediction);
cm.Title='Confusion Matrix for Test Data';
cm.RowSummary = 'row-normalized';
