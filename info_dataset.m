clear all; clc;
% gain information concerning dataset
% we want to get a overview on the snr value and the modulation of the
% corresponding signal_id in the spooner dataset

% init for spooner dataset from cyclostationary blog
n_batch=5;
n_signals_per_batch=4000;
path='/home/fabian/Ihr Team Dropbox/boston_2019/data/raw/';
file_id=fopen([path 'signal_record_first_20000.txt']);


label=categorical(zeros(n_signals_per_batch*n_batch,1));
snr=zeros(n_signals_per_batch*n_batch,1);
freq_off=snr;

signal_id=1;
for i=1:n_batch
    cur_path=[path 'Batch_Dir_' num2str(i)];
    for j=1:n_signals_per_batch
        % get signal information for current signal
        signal_info=textscan(file_id,'%f64 %s %f64 %f64 %f64 %f64 %f64 %f64 %f64',1,'headerlines',0);
        signal_modulation=string(signal_info{2});
        signal_snr=signal_info{8};
        signal_freq_off=signal_info{4};
        
        label(signal_id)=signal_modulation;
        snr(signal_id)=signal_snr;
        freq_off(signal_id)=signal_freq_off;
                
        disp(signal_id);
        signal_id=signal_id+1;        
    end
end
label=removecats(label,"0");

save('snr_dataset','snr');
save('label_dataset','label');
save('freq_off_dataset','freq_off');