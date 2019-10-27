clear all; close all;
% non limp ampl for dataset_1024_10000_snr_0_20.mat
path_data='/home/fabian/universitaet/paper_boston19/datasets/';
name_data='dataset_1024_10000_snr_0_20.mat';
l=load([path_data name_data]);
data=l.data;
label=l.label_data;

% load network
path_net='/home/fabian/universitaet/paper_boston19/networks/';
name_net='ref_1024_10000_snr_0_20.mat';
l=load([path_net name_net]);
trained_network=l.trained_network;

size_sample=numel(data(1,:,1,1));
n_sample=numel(label);
maxima=zeros(n_sample,1);
minima=maxima;
for i=1:n_sample
    cur_real=data(1,:,1,i);
    cur_imag=data(1,:,2,i);
    maxima(i)=max(max(cur_real),max(cur_imag));
    minima(i)=min(min(cur_real),min(cur_imag));
end

p_cut=0.1;
max_cut=min(maxk(maxima,floor(n_sample*p_cut)));
min_cut=max(mink(minima,floor(n_sample*p_cut)));

f_scale=min(abs(max_cut),abs(min_cut));
% interpolate
n=8;
d=3;
b=linspace(-f_scale,f_scale,n);
a=tanh(b);
coeffs=polyfit(b,a,d);

data_ampl=zeros(1,size_sample,2,n_sample);
for i=1:n_sample
    cur_real=data(1,:,1,i);
    cur_imag=data(1,:,2,i);
        
    cur_real(cur_real>=f_scale)=f_scale;
    cur_real(cur_real<=-f_scale)=-f_scale;
    cur_imag(cur_imag>=f_scale)=f_scale;
    cur_imag(cur_imag<=-f_scale)=-f_scale;
    
%     cur_real(abs(cur_real)~=f_scale)=interp1(b,a,cur_real(abs(cur_real)~=f_scale));
%     cur_imag(abs(cur_imag)~=f_scale)=interp1(b,a,cur_imag(abs(cur_imag)~=f_scale));
    
    cur_real(abs(cur_real)~=f_scale)=polyval(coeffs,cur_real(abs(cur_real)~=f_scale));
    cur_imag(abs(cur_imag)~=f_scale)=polyval(coeffs,cur_imag(abs(cur_imag)~=f_scale));
    
    data_ampl(1,:,1,i)=cur_real;
    data_ampl(1,:,2,i)=cur_imag;
end

% split data
[perm_training,perm_validation,perm_test]=split2(label);

test_data=data_ampl(:,:,:,perm_test);
test_label=label(perm_test);

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
