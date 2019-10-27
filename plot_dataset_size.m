path_net='/home/fabian/universitaet/paper_boston19/networks/';
path_data='/home/fabian/universitaet/paper_boston19/datasets/';

dataset_size=[1000 2500 5000 7500 10000 20000];
order=["msk","bpsk","qpsk","dqpsk","8psk","16qam","64qam","256qam"];

accuracies=zeros(numel(dataset_size),1);
% p_8psk=accuracies;
% p_dqpsk=accuracies;
for i=1:numel(dataset_size)
    name_net=['ref_1024_' num2str(dataset_size(i)) '_snr_0_20.mat'];
    name_data=['dataset_1024_' num2str(dataset_size(i)) '_snr_0_20.mat'];
    
    cur_net=load([path_net name_net]);
    cur_net=cur_net.trained_network;
    
    cur_dataset=load([path_data name_data]);
    cur_data=cur_dataset.data;
    cur_data_label=cur_dataset.label_data;
    
    [~,~,perm_test]=split2(cur_data_label);
    cur_test_data=cur_data(:,:,:,perm_test);
    cur_test_label=cur_data_label(perm_test);
    
    cur_pred=classify(cur_net,cur_test_data);
    cur_accuracy=sum(cur_test_label==cur_pred)/numel(cur_test_label);
    
    accuracies(i)=cur_accuracy;
    subplot(4,2,i);
    cm=confusionchart(cur_test_label,cur_pred);
    sortClasses(cm,order);
    
    cm_matrix=cm.NormalizedValues;
%     p_8psk(i)=cm_matrix(order=="8psk",order=="8psk")/sum(cm_matrix(order=="8psk",:));
%     p_dqpsk(i)=cm_matrix(order=="dqpsk",order=="dqpsk")/sum(cm_matrix(order=="dqpsk",:));

    cm.Title=['Confusion Matrix for Test Data ' num2str(dataset_size(i))];
    cm.RowSummary = 'row-normalized';

    disp(i);
    clear cur_net cur_dataset;
end

figure();
set(gcf, 'position',[100 100 600 400]); 
plot(dataset_size,accuracies,'--s','linewidth',1,'markersize',8,'markeredgecolor','red','markerfacecolor',[1 .6 .6]); hold on
labels=num2str(8*dataset_size')+"";
% text(dataset_size(1:end-2)+128,accuracies(1:end-2),labels(1:end-2),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',10);
% text(dataset_size(end-1:end),accuracies(end-1:end)-0.002,labels(end-1:end),'VerticalAlignment','top','HorizontalAlignment','center','FontSize',10);
text(dataset_size, accuracies+0.005,labels,'VerticalAlignment','middle','HorizontalAlignment','center','FontSize',10);
y_labels=accuracies;
yticks(unique(round(y_labels,2)));
yticklabels(unique(string(num2str(round(y_labels,2),'%12.2f'))));
xticks([]);
axis([0 max(dataset_size)+2000 min(accuracies)-0.01 max(accuracies)+0.01]);
% save

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'dataset_size','-depsc')