clear all;
% load network
path_net='/home/fabian/universitaet/paper_boston19/networks/';
name_net='ref_1024_20000_snr_0_20.mat';
l=load([path_net name_net]);
trained_network=l.trained_network;

% load data
path_data='/home/fabian/universitaet/paper_boston19/datasets/';
name_data='dataset_1024_20000_snr_0_20.mat';
l=load([path_data name_data]);
data=l.data;
label=l.label_data;

% split data
[perm_training,perm_validation,perm_test]=split2(label);

% training_data=data(:,:,:,perm_training);
% training_label=label(perm_training);
test_data=data(:,:,:,perm_test);
test_label=label(perm_test);
% validation_data=data(:,:,:,perm_validation);
% validation_label=label(perm_validation);


% test
prediction=classify(trained_network,test_data);
accuracy=sum(test_label==prediction)/numel(test_label)

% plots
order=["msk","bpsk","qpsk","dqpsk","8psk","16qam","64qam","256qam"];
figure;
set(gcf,'position',[100 100 600 400]); 
cm=confusionchart(test_label,prediction);
sortClasses(cm,order);
cm.RowSummary = 'row-normalized';

% save
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'cm_20000','-depsc')