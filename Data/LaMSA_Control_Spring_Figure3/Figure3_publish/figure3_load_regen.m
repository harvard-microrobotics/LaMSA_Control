
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
%% Figure 3B
% Description : Spring foce over strain WITHOUT external field
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
gu1 = open('Fig.3A.fig');
ax2 = gca;
box off
pause(1)
% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;

% label axes
xlabel('strain \epsilon','FontSize',8*font_scale)
ylabel('spring force','FontSize',8*font_scale)
ylabel('spring force $\frac{F}{2Ehw_0}$','FontSize',8*font_scale,'interpreter','latex')

% redo legend font
legend({'strip','a_0 = b_0','a_0 = 0.1b_0'},'FontSize',6*font_scale,'Location','SouthEast')

% remove title
title('Fig.3 B (without external field)')

% colect line handles
h = findobj(gca,'Type','line');

% axis square;

% set line colors individually
h(1).Color = blue;
h(1).LineWidth = 1.5;

h(2).Color = red;
h(2).LineWidth = 1.5;

h(3).Color = [0 0 0];
h(3).LineWidth = 1.5;

% set limits
ylim([0 2])

%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3C
% Description : recoil velocity over strain WITHOUT external field
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
gu1 = open('Fig.3B.fig');
ax2 = gca;
box off
pause(1)
% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;

% label axes
xlabel('strain \epsilon','FontSize',8*font_scale)
ylabel('recoil velocity','FontSize',8*font_scale)
ylabel('recoil velocity $\frac{V}{c_0}$','FontSize',8*font_scale,'Interpreter','latex')

% remove legend
leg = legend('word');
set(leg,'visible','off');

% remove title
title('Fig.3 C (without external field)')

% colect line handles
h = findobj(gca,'Type','line');

% axis square;

% set line colors individually
h(1).Color = blue;
h(1).LineWidth = 1.5;

h(2).Color = red;
h(2).LineWidth = 1.5;

h(3).Color = [0 0 0];
h(3).LineWidth = 1.5;

% add markers
hold on
plot(0.3,0.17314,'o','Color',red,'linewidth',1.5,'MarkerSize',8)
plot(0.3,0.05189,'o','Color',blue,'linewidth',1.5,'MarkerSize',8)

% set limits
ylim([0 1])
xlim([0 1])

%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3D
% Description : Energy efficiency over strain WITHOUT external field
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
gu1 = open('Fig.3C.fig');
ax2 = gca;
box off
pause(1)
% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;

% label axes
xlabel('strain \epsilon','FontSize',8*font_scale)
ylabel('energy efficiency \eta','FontSize',8*font_scale)

% remove legend
leg = legend('word');
set(leg,'visible','off');

% remove title
title('Fig.3 D (without external field)')


% colect line handles
h = findobj(gca,'Type','line');

% axis square;

% set line colors individually
h(1).Color = blue;
h(1).LineWidth = 1.5;

h(2).Color = red;
h(2).LineWidth = 1.5;

h(3).Color = [0 0 0];
h(3).LineWidth = 1.5;

% add markers
hold on
plot(0.3,0.74392,'o','Color',red,'linewidth',1.5,'MarkerSize',8)
plot(0.3,0.34785,'o','Color',blue,'linewidth',1.5,'MarkerSize',8)

% set limits
ylim([0 1])
xlim([0 1])

%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3B
% Description : Spring foce over strain WITH external field alpha=1
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
gu1 = open('Fig.3D.fig');
ax2 = gca;
box off
pause(1)
% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;

% label axes
xlabel('strain \epsilon','FontSize',8*font_scale)
ylabel('spring force','FontSize',8*font_scale)
%ylabel('spring force $\frac{F}{2Ehw_0}$','FontSize',8*font_scale,'interpreter','latex')

% redo legend font
legend({'strip','a_0 = b_0','a_0 = 0.1b_0'},'FontSize',6*font_scale,'Location','SouthEast')
% legend('strip','a_0 = b_0','a_0 = 0.1b_0','FontSize',floor(8*font_scale*10)/10,'Location','SouthEast')

% remove title
title('Fig.3 B (with external field)')


% colect line handles
h = findobj(gca,'Type','line');

% axis square;

% set line colors individually
h(1).Color = blue;
h(1).LineWidth = 1.5;

h(2).Color = red;
h(2).LineWidth = 1.5;

h(3).Color = [0 0 0];
h(3).LineWidth = 1.5;

% set line styles
h(1).LineStyle = '--';
h(2).LineStyle = '--';
h(3).LineStyle = '--';

% set limits
ylim([0 2])

%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3C
% Description : recoil velocity over strain WITH external field alpha=1
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
gu1 = open('Fig.3E.fig');
ax2 = gca;
box off
pause(1)
% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;

% label axes
xlabel('strain \epsilon','FontSize',8*font_scale)
ylabel('recoil velocity','FontSize',8*font_scale)
%ylabel('recoil velocity $\frac{V}{c_0}$','FontSize',8*font_scale,'Interpreter','latex')

% remove legend
leg = legend('word');
set(leg,'visible','off');

% remove title
title('Fig.3 C (with external field)')

% colect line handles
h = findobj(gca,'Type','line');

% axis square;

% set line colors individually
h(1).Color = blue;
h(1).LineWidth = 1.5;

h(2).Color = red;
h(2).LineWidth = 1.5;

h(3).Color = [0 0 0];
h(3).LineWidth = 1.5;

% set line styles
h(1).LineStyle = '--';
h(2).LineStyle = '--';
h(3).LineStyle = '--';

% set limits
ylim([0 1])
xlim([0 1])

% add markers
hold on
plot(0.3,0.25783,'s','Color',red,'linewidth',1.5,'MarkerSize',9)
plot(0.3,0.10215,'s','Color',blue,'linewidth',1.5,'MarkerSize',9)

%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3D
% Description : Energy efficiency over strain WITH external field alpha=1
%%%%%%%%%%%%%%%%%%%%%%
% open figure and retrieve axes and children
pause(1)
gu1 = open('Fig.3F.fig');
ax2 = gca;
box off
pause(1);
% set tick font size
tick_x = ax2.XAxis;
tick_y = ax2.YAxis;
tick_x.FontSize = 6*font_scale;
tick_y.FontSize = 6*font_scale;

% label axes
xlabel('strain \epsilon','FontSize',8*font_scale)
ylabel('energy efficiency \eta','FontSize',8*font_scale)

% remove legend
leg = legend('word');
set(leg,'visible','off');

% remove title
title('Fig.3 D (with external field)')

% colect line handles
h = findobj(gca,'Type','line');

% axis square;

% set line colors individually
h(1).Color = blue;
h(1).LineWidth = 1.5;

h(2).Color = red;
h(2).LineWidth = 1.5;

h(3).Color = [0 0 0];
h(3).LineWidth = 1.5;

% set line styles
h(1).LineStyle = '--';
h(2).LineStyle = '--';
h(3).LineStyle = '--';

% set limits
ylim([0 1])
xlim([0 1])

% add markers
hold on
plot(0.3,0.87196,'s','Color',red,'linewidth',1.5,'MarkerSize',9)
plot(0.3,0.67393,'s','Color',blue,'linewidth',1.5,'MarkerSize',9)