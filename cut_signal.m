function y=cut_signal(signal,size,offset)
    length_signal=numel(signal);
    n_frames=length_signal/size-1; % not in general
    y=zeros(size,n_frames);
    
    cur_frame_index=1;
    index=offset+randi([2 50]); % offset
    while (index+size)<length_signal
        cur_frame=signal(index:index+size-1);
        power=sum(abs(cur_frame).^2);
        cur_frame=cur_frame/sqrt(power);
        y(:,cur_frame_index)=cur_frame;
       
        cur_frame_index=cur_frame_index+1;
        index=index+size;
    end
end