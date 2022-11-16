
clear all
clc
close all

% save flag
savecommand = false;

% normalizing flag
normalizecommand = true;

% Input System Parameters
unlatchingTime = 0e-3; % seconds
StartExtensorForce = 15; % N
StartStiffness = 1/2 * 15 * 15 / (0.00768); % N/m
Mass = 1.5e-3; % kg
TibiaLength = 22e-3; % m
FemurLength = 22e-3; %m
ExtensorMomentArm = 0.37e-3 * TibiaLength/.0085; %m 9.5e-4
FlexorMomentArm = 0.77e-3 * TibiaLength/.0085; %m
% ExtensorOffset = fliplr([-30,-20,-10,-5,0]); % degrees
ExtensorOffset = fliplr([-25:2.5:0]); % degrees
FlexorOffset = 85; % degrees
InitialFlexionAngle = 5; % degrees
% TimeDelay = fliplr([0.01,5,10,15,20]).*1e-3; % seconds
TimeDelay = fliplr([20]).*1e-3; % seconds

% General Parameters
dt = 1e-6; % seconds
Endtime = 60e-3; % seconds

% normalizing factor for performance
v_max = 3.04; %m/s, this is what we get from Greg's inital file with all grasshopper's parameters

% solve grasshopper model to obtain leg angle, displacement, velocity
% and accelertion
for i = 1:length(ExtensorOffset)
    [outputParams{i},outputMisc{i}] = GrasshopperModel_decay([unlatchingTime,...
        StartExtensorForce,StartStiffness,Mass,TibiaLength,FemurLength,...
        ExtensorMomentArm,FlexorMomentArm,ExtensorOffset(i),FlexorOffset,...
        InitialFlexionAngle,TimeDelay],[dt,Endtime]);
    time{i} = outputParams{i}.Data(:,1).*1000; % ms
    legAngle{i} = real(outputParams{i}.Data(:,2)); % degrees
    x{i} = outputParams{i}.Data(:,3).*1000; %mm
    velocity{i} = real(outputParams{i}.Data(:,4)); %m/s
    acceleration{i} = real(outputParams{i}.Data(:,5)); %m/s^2
    unlatchingIndex{i} = outputParams{i}.unlatchingIndex;
    unlatchedIndex{i} = outputParams{i}.unlatchedIndex;
    takeoffIndex{i} = outputParams{i}.takeoffIndex;
    energyOutput{i}  = 0.5.*Mass.*velocity{i}.^2;
    trackers(i,:) = [outputParams{i}.tracker,outputParams{i}.tracker2];
    
    if normalizecommand
        velocity{i} = velocity{i}./v_max;
%         energyOutput{i} = energyOutput{i}./(0.5.*StartStiffness.*(StartExtensorForce./StartStiffness)^2);
        energyOutput{i} = energyOutput{i}./(0.5.*Mass.*3.0404^2);

    end
    
end

% temp outputs

% plot definitions
lineWidth = 2.0; markerSize = 10; 
min_c = 0;
max_c = 25;
numc = max_c-min_c+1;
% colorMap = flipud([50, 98, 252;8, 178, 227;127, 184, 0;207, 99, 121;186, 18, 0;30, 50, 49])./255;
colorMap  = flipud(brewermap(numc,'Spectral'));

% plot - energy
figure(4)
hold on; 
ax_fig = gca;
c2 = colorbar;
colormap(ax_fig,colorMap);
caxis([min_c, max_c]);
% caxis([-max_c, -min_c]);
c2Label = xlabel(c2, '$\phi_{ext}$ ($^{\circ}$)','interpreter','Latex');
% set( c2, 'YDir', 'reverse' );

% legch(i) = cellstr(['$\phi_{ext}$ = ',num2str(ExtensorOffset(i)),'$^{\circ}$']);
plotColor = [];
for i = 1:length(ExtensorOffset)
    plot_color = colorMap(round(abs(ExtensorOffset(i))-min_c+1),:);
    plotColor = [plotColor;plot_color];
    p1(i) = plot(time{i}(1:takeoffIndex{i}),energyOutput{i}(1:takeoffIndex{i}),'Color',plot_color);
    p1b(i) = plot(time{i}(unlatchedIndex{i}),energyOutput{i}(unlatchedIndex{i}),...
        'Marker','o','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
    p1c(i) = plot(time{i}(takeoffIndex{i}),energyOutput{i}(takeoffIndex{i}),'Marker','d',...
        'MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]); 
end
p1a_new = plot(10,10,'ok');
p1b_new = plot(10,10,'dk');
legend([p1a_new,p1b_new],{'unlatched','take-off'},'interpreter','latex','location','northwest');
% for i = 1:length(ExtensorOffset)
% %     p1a(i) = plot(time{i}(unlatchingIndex{i}),velocity{i}(unlatchingIndex{i}),'^g','MarkerSize',markerSize,'LineWidth',lineWidth);
%     p1b(i) = plot(time{i}(unlatchedIndex{i}),energyOutput{i}(unlatchedIndex{i}),'og','MarkerSize',markerSize,'LineWidth',lineWidth);
%     p1c(i) = plot(time{i}(takeoffIndex{i}),energyOutput{i}(takeoffIndex{i}),'dm','MarkerSize',markerSize,'LineWidth',lineWidth);
% end
yLim = ylim;
xlabel('Time $t$ (ms)','interpreter','latex');
if normalizecommand
    ylabel('Energy Output $\tilde{E}_{out}$','interpreter','latex');
    ylim([0 1.1]);
else
    ylabel('Energy Output $E_{out}$ (J)','interpreter','latex');
end
caxis([-25,0]);
for i = 1:length(p1)
    p1(i).Color = plotColor(end-i+1,:);
    p1b(i).MarkerEdgeColor = plotColor(end-i+1,:);
    p1c(i).MarkerEdgeColor = plotColor(end-i+1,:);
end
set(c2, 'Direction', 'reverse');
if (savecommand)
    fpath = strcat(pwd,'/timedelayplots/10152020');
    if normalizecommand  
        filename1 = ['Fig3H'];
    else
        filename1 = ['GeoLatch_Energy_Geometry'];
    end
    saveas(gcf,fullfile(fpath,filename1),'svg');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'fig');
end

a = 1;

% plot - force
figure(5)
hold on; 
ax_fig = gca;
c2 = colorbar;
colormap(ax_fig,colorMap);
caxis([min_c,max_c]);
c2Label = xlabel(c2, '$\phi_{ext}$ ($^{\circ}$)','interpreter','Latex');
plotColor = [];
for i = 1:length(ExtensorOffset)
    plot_color = colorMap(round(abs(ExtensorOffset(i))-min_c+1),:);
    plotColor = [plotColor;plot_color];
    p1(i) = plot(time{i}(1:takeoffIndex{i}),outputMisc{i}(1:takeoffIndex{i},1)./StartExtensorForce,...
        'Color',plot_color);
    p1b(i) = plot(time{i}(unlatchedIndex{i}),outputMisc{i}(unlatchedIndex{i},1)./StartExtensorForce,...
        'Marker','o','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
    p1c(i) = plot(time{i}(takeoffIndex{i}),outputMisc{i}(takeoffIndex{i},1)./StartExtensorForce,...
        'Marker','d','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
end
p1a_new = plot(10,10,'ok');
p1b_new = plot(10,10,'dk');
legend([p1a_new,p1b_new],{'unlatched','take-off'},'interpreter','latex','location','northwest');
yLim = ylim;
xlabel('Time $t$ (ms)','interpreter','latex');
ylabel('Latch Force $F_{latch}$ (N)','interpreter','latex');
ylim([0 1]);
caxis([-25,0]);
for i = 1:length(p1)
    p1(i).Color = plotColor(end-i+1,:);
    p1b(i).MarkerEdgeColor = plotColor(end-i+1,:);
    p1c(i).MarkerEdgeColor = plotColor(end-i+1,:);
end
set(c2, 'Direction', 'reverse');
if (savecommand)
    fpath = strcat(pwd,'/timedelayplots/10152020');
    if normalizecommand  
        filename1 = ['Fig3G'];
    else
        filename1 = ['GeoLatch_LatchForce_Geometry'];
    end
    saveas(gcf,fullfile(fpath,filename1),'svg');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'fig');
end



