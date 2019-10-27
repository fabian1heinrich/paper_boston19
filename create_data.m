clear all; clc;

path='/home/fabian/universitaet/paper_boston19/data/';

% modulation types that will be featured in our dataset
modulation_types=categorical(["16qam","8psk", "bpsk","qpsk","msk","dqpsk","64qam","256qam"]);
n_mod_types=numel(modulation_types);

% number of samples per modulation typ
n_samples_per_mod=5000;
% number of samples in entire dataset
n_data=n_samples_per_mod*n_mod_types;

% sample values per signal
size_sample=8192;

% restrictions for snr
min_snr=0;
max_snr=20;

% gain information concerning dataset
snr=load('snr_dataset.mat');
snr=snr.snr;
label=load('label_dataset.mat');
label=label.label;
freq_off=load('freq_off_dataset.mat');
freq_off=freq_off.freq_off;

index_matrix=zeros(2500,n_mod_types);
% snr restrictions
index_snr=find((snr>=min_snr).*(snr<max_snr));
% frequency offset restrictions
for i=1:n_mod_types
    % index current modulation type
    index_mod=find(label==modulation_types(i),2500);
    % get index of current modulation type with regard to snr
    index=intersect(index_mod,index_snr);
    % shuffle
    index=index(randperm(numel(index)));
    % insert current modualtion type
    index_matrix(1:numel(index),i)=index;
end

% init
data=zeros(1,size_sample,2,n_samples_per_mod*n_mod_types);
label_data=categorical(zeros(n_samples_per_mod*n_mod_types,1));
snr_data=zeros(n_samples_per_mod*n_mod_types,1);
signal_id=snr_data;
e=1;
for i=1:n_mod_types
    index=index_matrix(:,i);
    index(index==0)=[];
    n_signals=numel(index);
    n_frames_per_signal=max(1,floor(n_samples_per_mod/n_signals));
    
    j=1;
    while e<(i*n_samples_per_mod)
        cur_j=mod(j-1,n_signals)+1;
        % get signal from dataset
        batch_id=floor((index(cur_j)-1)/4000)+1;
        cur_path=[path 'Batch_Dir_' num2str(batch_id)];
        signal=read_binary(cur_path,['signal_' num2str(index(cur_j)) '.tim']);
        
        % cut signals into frames
        frames=cut_signal(signal,size_sample,32);
        [~,n_frames]=size(frames);
        % shuffle
        rng(712+index(cur_j))
        perm=randperm(n_frames,n_frames_per_signal);
        frames=frames(:,perm);
        
        % normalize
        for k=numel(frames(1,:))
            cur_frame=frames(:,k);
            energy=sum(abs(cur_frame).^2);
            frames(:,k)=cur_frame/energy;
        end
        
        % store frames/get labels
        % start index
        s=((i-1)*n_samples_per_mod+1)+(j-1)*n_frames_per_signal;
        % end index
        e=s+n_frames_per_signal-1;
        
        % end index exceeds number of samples per mod
        if e>=(i*n_samples_per_mod)
            e=(i*n_samples_per_mod);
            s=e-n_frames_per_signal+1;
        end
        
        % store frames and labels
        data(1,:,1,s:e)=real(frames);
        data(1,:,2,s:e)=imag(frames);
        label_data(s:e)=modulation_types(i);
   
        % store snr and signal_id to check
        snr_data(s:e)=snr(index(cur_j));
        signal_id(s:e)=index(cur_j);
        
        j=j+1;
        disp([num2str(i) '-' num2str(j)]);
    end
end
label_data=removecats(label_data,"0");

% init shuffle in case of further use
rng(712)
shuffle_perm=randperm(numel(label_data));
data=data(:,:,:,shuffle_perm);
label_data=label_data(shuffle_perm);

% test for 'legitness'
% should be close to (max_snr-min_snr)/2
mean_snr=mean(snr_data)
% supposed to be proportional with regard to snr range and samples per modulation type
numel(unique(signal_id))

name_save=['dataset_' num2str(size_sample) '_' num2str(n_samples_per_mod) '_snr_' num2str(min_snr) '_' num2str(max_snr)];
save(['/home/fabian/universitaet/paper_boston19/datasets/' name_save],...
      'data','label_data','-v7.3');