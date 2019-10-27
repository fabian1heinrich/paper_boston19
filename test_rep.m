clear all;
% load network
path_net='/home/fabian/universitaet/paper_boston19/networks/';
name_net='ref_4096_10000_snr_0_20.mat';
l=load([path_net name_net]);
trained_network=l.trained_network;

% load data
path_data='/home/fabian/universitaet/paper_boston19/datasets/';
name_data='dataset_2048_10000_snr_0_20.mat';
l=load([path_data name_data]);
data=l.data;
label=l.label_data;

% rep data
n_sample=numel(data(1,1,1,:));
size_sample=numel(data(1,:,1,1));
size_rep=4096;
data_rep=zeros(1,size_rep,2,n_sample);
rep_factor=ceil(size_rep/size_sample);

for i=1:n_sample
    cur_real=data(1,:,1,i);
    cur_imag=data(1,:,2,i);
    cur_real=repmat(cur_real,[1 rep_factor]);
    cur_imag=repmat(cur_imag,[1 rep_factor]);
    cur_real=cur_real(1:size_rep);
    cur_imag=cur_imag(1:size_rep);
    
    data_rep(1,:,1,i)=cur_real;
    data_rep(1,:,2,i)=cur_imag;
    disp(i)
end

% split data
[perm_training,perm_validation,perm_test]=split2(label);
test_data=data_rep(:,:,:,perm_test);
test_label=label(perm_test);

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