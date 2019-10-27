clear all;
% load network
path_net='/home/fabian/universitaet/paper_boston19/networks/';
name_net='ref_1024_10000_snr_0_20.mat';
l=load([path_net name_net]);
trained_network=l.trained_network;

% load data
path_data='/home/fabian/universitaet/paper_boston19/datasets/';
name_data='dataset_1024_10000_snr_0_20.mat';
l=load([path_data name_data]);
data=l.data;
label=l.label_data;

% prepare data
data_ampl=zeros(1,1024,2,numel(label));
% resample data
for i=1:numel(label)
    cur_real=data(1,:,1,i);
    cur_imag=data(1,:,2,i);
    ampl_real=fabians_non_lin_ampl(cur_real);
    amp_imag=fabians_non_lin_ampl(cur_imag);
   
    data_ampl(1,:,1,i)=ampl_real;
    data_ampl(1,:,2,i)=amp_imag;
end


% split data
[perm_training,perm_validation,perm_test]=split2(label);

training_data=data(:,:,:,perm_training);
training_label=label(perm_training);
test_data=data_ampl(:,:,:,perm_test);
test_label=label(perm_test);
validation_data=data(:,:,:,perm_validation);
validation_label=label(perm_validation);


% test
prediction=classify(trained_network,test_data);
accuracy=sum(test_label==prediction)/numel(test_label)

% plots
order=["msk","bpsk","qpsk","dqpsk","8psk","16qam","64qam","256qam"];
figure;
set(gcf, 'position',[100 100 466 350]); 
cm=confusionchart(test_label,prediction);
sortClasses(cm,order);
% cm.Title='Confusion Matrix for Test Data';
cm.RowSummary = 'row-normalized';