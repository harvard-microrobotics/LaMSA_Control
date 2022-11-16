clear all;
close all;

% create font scale for reducing plot size but keeping font at same scale
font_scale = 2.472;
%font_scale = 5.3027;

% color RGBs
green  = [0,176/255,80/255];
orange = [0.96,0.75,0.26];
purple = [112/255,48/255,160/255];
blue   = [0, 112/255, 192/255];
red    = [192/255, 0 , 0];
gold   = [191/255,144/255,0];



%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3E velocity
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
figG_vel = open('Fig.3G_velocity.fig');

% retreive contour data
h = gcf;
axesObjs = get(h, 'Children');
contourdata = get(axesObjs, 'Children');
XData = contourdata.XData;
YData = contourdata.YData;
CData = contourdata.CData;

% clear figure
clf
% replot data
contourf(XData,YData,CData,'edgecolor','none');

ax2 = gca;
box off

% create colorbar
c2 = colorbar;
color_map1 = brewermap(20,'YlGnBu');
colormap(ax2,color_map1)
caxis([0, 0.3])

% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;
c2.FontSize = 6*font_scale;

% remove title
title('')

% label axes
xlabel('pore shape $\frac{a_0}{b_0}$','FontSize',8*font_scale,'interpreter','latex')
ylabel('external field $a$','FontSize',8*font_scale,'Interpreter','latex')
ylabel(c2,'$V/c_0$','FontSize',8*font_scale,'Interpreter','latex')

% add markers
hold on
plot(1,0,'o','Color',red,'linewidth',1.5,'MarkerSize',8)
plot(0.1,0,'o','Color','k','linewidth',1.5,'MarkerSize',8)
plot(1,1,'s','Color',red,'linewidth',1.5,'MarkerSize',9)
plot(0.1,1,'s','Color','k','linewidth',1.5,'MarkerSize',9)


%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3F dissipation
%%%%%%%%%%%%%%%%%%%%%%
% clear h axesObjs contourdata
% open figure and retrieve axes and children
fig1 = open('Fig.3G_dissipation.fig');

pause(1);
% retreive contour data
h = gcf;
axesObjs = get(h, 'Children');
contourdata = get(axesObjs, 'Children');
XData = contourdata.XData;
YData = contourdata.YData;
CData = contourdata.CData;

% clear figure
clf
% replot data
contourf(XData,YData,CData,'edgecolor','none');

ax2 = gca;
box off

% create colorbar
c2 = colorbar;
color_map1 = brewermap(20,'YlGnBu');
colormap(ax2,color_map1)
caxis([0, 1])

% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;
c2.FontSize = 6*font_scale;

% remove title
title('')

% label axes
xlabel('pore shape a_0/b_0','FontSize',8*font_scale)
xlabel('pore shape $\frac{a_0}{b_0}$','FontSize',8*font_scale,'interpreter','latex')
ylabel('external field a','FontSize',8*font_scale)
ylabel(c2,'\eta','FontSize',8*font_scale)

% add markers
hold on
plot(1,0,'o','Color',red,'linewidth',1.5,'MarkerSize',8)
plot(0.1,0,'o','Color','k','linewidth',1.5,'MarkerSize',8)
plot(1,1,'s','Color',red,'linewidth',1.5,'MarkerSize',9)
plot(0.1,1,'s','Color','k','linewidth',1.5,'MarkerSize',9)

% axis square
%axis square

% set xlim
xlim([0.01 1])