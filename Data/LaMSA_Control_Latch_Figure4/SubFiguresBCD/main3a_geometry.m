% Code for generating figure 4 a and b 

clear all
clc 
close all

tic;

new_fig =@()figure();

% save flag: 
% true - saves plots in the folder titled plots in the following
% format: jpeg, svg, png, eps and fig. 
% false -  no save.
savecommand = false;
normalizecommand = true;

folderName = '/plots/01212021/B';

global params;

R = [0.001,1,2,3,4,5,6,7,8,9,10]; %mm
L = 10; %mm
deltaX = 10; %mm
m = 1.0; %grams
m_s = 0; %grams
k = 1000; %N/m

vL_thresh = sqrt(R.*1e-3.*deltaX.*1e-3.*k/((m+m_s).*1e-3)); %m/s
beta = [0.25 1.25];
% 
% if ~(R == 0.001)
%     vL_array = [round(beta(1).*vL_thresh,1):1: round(beta(2).*vL_thresh,1)];
% else
%     vL_array = 2; %m/s, arbitrarily chosen value
% end

vL_array = 1; %m/s

for i = 1:length(R)
    [t_s x_s v_s a_s F_s] = spring_driven_dynamics(deltaX*1e-3,L*1e-3,k,R(i)*1e-3,vL_array,m*1e-3,m_s*1e-3);
    KE_s = 0.5.*(m + m_s).*v_s.^2.*0.001;
    jF = F_s;
    sF = k.*(L.*0.001 - x_s);
    lF = sF - jF;
	if normalizecommand
        v_recoil = (sqrt(k/((m+m_s).*0.001)).*deltaX.*0.001);
        v_s = v_s./v_recoil;
        a_s = a_s./(deltaX.*0.001.*k/(1e-3.*(m+m_s)));
        KE_s = KE_s./(0.5.*(m+m_s).*0.001.*(v_recoil)^2);      
        lF = lF./(k.*deltaX.*0.001);
        sF = sF./(k.*deltaX.*0.001);
        jF = jF./(k.*deltaX.*0.001);
    end
    timeArray{i} = 1000.*t_s;
    xArray{i} = x_s;
    velocityArray{i} = v_s;
    accelerationArray{i} = a_s;
    springForce{i} = sF;
    unlatchingTime(i) = 1000.*params(1);
    unlatchingInd(i) = params(2);
    energyOutput{i} = KE_s;
    jumperForce{i} = jF;
    latchForce{i} = lF;
end

if normalizecommand
   R_bar = R./deltaX;      
%    vL_array_bar = round(vL_array./(v_recoil.*sqrt(R_bar)),2);
   vL_array_bar = vL_array./v_recoil;
   vL_thresh_bar = vL_thresh./v_recoil;
end

% plot features
lines = {'-','--','-.'};
% clrs = [0 0.447 0.7410;0.85 0.325 0.098;0.9290 0.6940 0.1250;0.49 0.1840 0.556;0.466 0.674 0.188;0.301 0.745 0.933;0.635 0.078 0.184;0.5 0.5 0.5;0.5 0.5 1;0 0 0];
% % single hue - 6 blues - http://colorbrewer2.org/#type=sequential&scheme=Blues&n=6
% clrs_b = [8,81,156;49,130,189;107,174,214;158,202,225;198,219,239;239,243,255]./255;
% % single hue - 6 greens - http://colorbrewer2.org/#type=sequential&scheme=Greens&n=6
% clrs_g = [0,109,44;49,163,84;116,196,118;161,217,155;199,233,192;237,248,233]./255;
% % single hue - 6 purples - http://colorbrewer2.org/#type=sequential&scheme=Purples&n=6
% clrs_p = [84,39,143;117,107,177;158,154,200;188,189,220;218,218,235;242,240,247]./255;
% % single hue - 6 oranges - http://colorbrewer2.org/#type=sequential&scheme=Oranges&n=6
% clrs_o = [166,54,3;230,85,13;253,141,60;253,174,107;253,208,162;254,237,222]./255;
% % single hue - 6 Green and Blue - http://colorbrewer2.org/#type=sequential&scheme=GnBu&n=6
% clrs_gb = [8,104,172;67,162,202;123,204,196;168,221,181;204,235,197;240,249,232]./255;
plotMarkers = {'o','+','*','.','x','s','d','^','>','<','p','h'};
lineWidth = 2.0;
markerSize = 10;

min_c = 0;
max_c = 10;
numc = max_c-min_c+1;

colorMap  = (brewermap(numc,'Spectral'));

a = 1;

figure(3)
hold on; 
ax_fig = gca;
c2 = colorbar;
colormap(ax_fig,colorMap);
caxis([min_c,max_c].*0.1);
c2Label = xlabel(c2, '$\tilde{R}$','interpreter','Latex');

for i = 1:length(R)
    plot_color = colorMap(round(R(i)-min_c+1),:);
    p1(i) = plot(timeArray{i},energyOutput{i},'Color',plot_color);
    if normalizecommand
        if ~(R(i) == 0.001)
            legch(i) = cellstr(['$\tilde{R}$ = ',num2str(R_bar(i))]);
        else
            legch(i) = cellstr(['$\tilde{R}$ = ',num2str(0)]);
        end
    else
        if ~(R(i) == 0.001)
            legch(i) = cellstr(['$R$ = ',num2str(R(i)),'mm']);
        else
            legch(i) = cellstr(['$R$ = ',num2str(0),'mm']);
        end
    end
    p1a(i) = plot(unlatchingTime(i),energyOutput{i}(unlatchingInd(i)),...
        'Marker','o','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
    p1b(i) = plot(timeArray{i}(end),energyOutput{i}(end),'Marker','d',...
        'MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);     
end
xlim([0 12]); % set this manually
ylim([0 1.1]);
p1a_new = plot(10,10,'ok');
p1b_new = plot(10,10,'dk');
legend([p1a_new,p1b_new],{'unlatched','take-off'},'interpreter','latex','location','northeast');
xlabel('Time $t$ (ms)','interpreter','Latex');
if normalizecommand
    ylabel('Energy Output $\tilde{E}_{out}$','Interpreter','latex');
else
    ylabel('Energy Output $E_{out}$ (J)','Interpreter','latex');
end
if (savecommand)
    fpath = strcat(pwd,folderName);
    filename1 = strrep(['Fig3C'],'.','p');
    saveas(gcf,fullfile(fpath,filename1),'fig');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'svg');  
end

figure(4)
hold on; 
ax_fig = gca;
c2 = colorbar;
colormap(ax_fig,colorMap);
caxis([min_c,max_c].*0.1);
c2Label = xlabel(c2, '$\tilde{R}$','interpreter','Latex');
for i = 1:length(R)
    plot_color = colorMap(round(R(i)-min_c+1),:);
    p1(i) = plot(timeArray{i},latchForce{i},'Color',plot_color);
    if normalizecommand
        if ~(R(i) == 0.001)
            legch(i) = cellstr(['$\tilde{R}$ = ',num2str(R_bar(i))]);
        else
            legch(i) = cellstr(['$\tilde{R}$ = ',num2str(0)]);
        end
    else
        if ~(R(i) == 0.001)
            legch(i) = cellstr(['$R$ = ',num2str(R(i)),'mm']);
        else
            legch(i) = cellstr(['$R$ = ',num2str(0),'mm']);
        end
    end
    p1a(i) = plot(unlatchingTime(i),latchForce{i}(unlatchingInd(i)),...
        'Marker','o','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
    p1b(i) = plot(timeArray{i}(end),latchForce{i}(end),'Marker','d',...
        'MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
end
xlabel('Time $t$ (ms)','interpreter','Latex');
if normalizecommand
    ylabel('Latch Force $\tilde{F}_{latch}$','Interpreter','latex');
else
    ylabel('Latch Force $F_{latch}$ (N)','Interpreter','latex');
end
xlim([0 12]); % set this manually
yLim = ylim;
ylim([yLim(1) 1.1]);
p1a_new = plot(10,10,'ok');
p1b_new = plot(10,10,'dk');
legend([p1a_new,p1b_new],{'unlatched','take-off'},'interpreter','latex','location','northeast');
if (savecommand)
    fpath = strcat(pwd,folderName);
    filename1 = strrep(['Fig3B'],'.','p');
    saveas(gcf,fullfile(fpath,filename1),'fig');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'svg');  
end

toc;
