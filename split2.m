function [perm_training, perm_validation, perm_test]=split2(label)
    n_samples=numel(label);
    p_training=0.8;
    % the test and validation set contain the remaining samples 

    [modulation_types,~,z]=unique(label);
    n_mod_types=numel(modulation_types);
    n_per_mod_type=min(accumarray(z,1));
    
    n_training_per_mod_type=floor(n_per_mod_type*p_training);
    n_validation_per_mod_type=floor((n_per_mod_type-n_training_per_mod_type)/2);
    n_test_per_mod_type=n_per_mod_type-n_training_per_mod_type-n_validation_per_mod_type;
    
    n_training=n_training_per_mod_type*n_mod_types;
    n_validation=n_validation_per_mod_type*n_mod_types;
    n_test=n_test_per_mod_type*n_mod_types;
    
    dummy=n_training_per_mod_type+n_validation_per_mod_type;
    
    perm_training=zeros(n_training,1);
    perm_validation=zeros(n_validation,1);
    perm_test=zeros(n_test,1);
   
    for i=1:n_mod_types
        index=find((label==modulation_types(i)));
        
        perm_training((i-1)*n_training_per_mod_type+1:i*n_training_per_mod_type)=index(1:n_training_per_mod_type);
        perm_validation((i-1)*n_validation_per_mod_type+1:i*n_validation_per_mod_type)=index(n_training_per_mod_type+1:dummy);
        perm_test((i-1)*n_test_per_mod_type+1:i*n_test_per_mod_type)=index(dummy+1:n_per_mod_type);
    end
end