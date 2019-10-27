function [training_data,training_label,test_data,test_label....
          ,validation_data,validation_label]= split_data(data,label,p)
      
%     rng(712)
    p_training=p(1);
    p_validation=p(2);
    p_test=p(3);
    
    training=[];
    validation=[];
    test=[];
    
    [x,~,z]=unique(label);
    z=accumarray(z,1);
    for i=1:numel(x)
        cur_perm=find(label==x(i))';
        perm_training=randperm(z(i),floor(z(i)*p_training));
        perm_remaining=setdiff(1:z(i),perm_training);
        perm_validation=randperm(numel(perm_remaining),floor(z(i)*p_validation));
        perm_remaining=setdiff(1:z(i),perm_validation);
        perm_test=randperm(numel(perm_remaining),floor(z(i)*p_test));
        
        training=[training cur_perm(perm_training)];
        validation=[validation cur_perm(perm_validation)];
        test=[test cur_perm(perm_test)];
    end
    
    training_data=data(:,:,:,training);
    training_label=label(training);
    validation_data=data(:,:,:,validation);
    validation_label=label(validation);
    test_data=data(:,:,:,test);
    test_label=label(test);
    [test; validation]'
end