close all;

figure();
% set(gcf, 'position',[100 100 2400 3600]);
plot(layer_graph)
set(gca,'fontsize',90)
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'res_layer_graph','-depsc')