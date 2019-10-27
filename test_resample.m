clear all;
% load network
path_net='/home/fabian/universitaet/paper_boston19/networks/';
name_net='ref_1024_10000_snr_0_20.mat';
l=load([path_net name_net]);
trained_network=l.trained_network;

% load data
path_data='/home/fabian/universitaet/paper_boston19/datasets/';
name_data='dataset_512_10000_snr_0_20.mat';
l=load([path_data name_data]);
data=l.data;
label=l.label_data;

cur_size=numel(data(1,:,1,1));
res_size=1024;
res_factor=res_size/cur_size;
data_resample=zeros(1,res_size,2,numel(label));
% resample data
for i=1:numel(label)
    cur_real=data(1,:,1,i);
    cur_imag=data(1,:,2,i);
    res_real=resample(cur_real,res_factor,1);
    res_imag=resample(cur_imag,res_factor,1);
   
    data_resample(1,:,1,i)=res_real;
    data_resample(1,:,2,i)=res_imag;
end

% split data
[perm_training,perm_validation,perm_test]=split2(label);

training_data=data_resample(:,:,:,perm_training);
training_label=label(perm_training);
test_data=data_resample(:,:,:,perm_test);
test_label=label(perm_test);
validation_data=data_resample(:,:,:,perm_validation);
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