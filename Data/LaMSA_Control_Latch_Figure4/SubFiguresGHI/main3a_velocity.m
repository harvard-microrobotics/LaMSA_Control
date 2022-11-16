
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
ExtensorOffset = fliplr([-25]); % degrees
FlexorOffset = 85; % degrees
InitialFlexionAngle = 5; % degrees
% TimeDelay = fliplr([0.01,5,10,15,20]).*1e-3; % seconds
TimeDelay = [0:2.5:25].*1e-3; % seconds

% General Parameters
dt = 1e-6; % seconds
Endtime = 60e-3; % seconds

% normalizing factor for performance
v_max = 3.04; %m/s

% solve grasshopper model to obtain leg angle, displacement, velocity
% and accelertion
for i = 1:length(TimeDelay)
    [outputParams{i},outputMisc{i}] = GrasshopperModel_decay([unlatchingTime,...
        StartExtensorForce,StartStiffness,Mass,TibiaLength,FemurLength,...
        ExtensorMomentArm,FlexorMomentArm,ExtensorOffset,FlexorOffset,...
        InitialFlexionAngle,TimeDelay(i)],[dt,Endtime]);
    time{i} = outputParams{i}.Data(:,1).*1000; % ms
    legAngle{i} = real(outputParams{i}.Data(:,2)); % degrees
    x{i} = outputParams{i}.Data(:,3).*1000; %mm
    velocity{i} = real(outputParams{i}.Data(:,4)); %m/s
    acceleration{i} = real(outputParams{i}.Data(:,5)); %m/s^2
    unlatchingIndex{i} = outputParams{i}.unlatchingIndex;
    unlatchedIndex{i} = outputParams{i}.unlatchedIndex;
    takeoffIndex{i} = outputParams{i}.takeoffIndex; 
    energyOutput{i}  = 0.5.*Mass.*velocity{i}.^2;
    trackers(i,:) = [outputParams{i}.tracker,outputParams{i}.tracker2]
    
    if normalizecommand
        velocity{i} = velocity{i}./v_max;
        energyOutput{i} = energyOutput{i}./(0.5.*Mass.*3.0404^2);
    end
    
end

% plot definitions
lineWidth = 2.0; markerSize = 10; 
min_c = 0;
max_c = 25;
numc = max_c-min_c+1;
colorMap  = brewermap(numc,'Spectral');


% plot - energy output
figure(4)
hold on; 
ax_fig = gca;
c2 = colorbar;
colormap(ax_fig,colorMap);
caxis([min_c, max_c]);
c2Label = xlabel(c2, '$\delta_{L}$ (ms)','interpreter','Latex');

for i = 1:length(TimeDelay)
    plot_color = colorMap(round(TimeDelay(i).*1000-min_c+1),:);
    p1(i) = plot(time{i}(1:takeoffIndex{i}),energyOutput{i}(1:takeoffIndex{i}),'Color',plot_color);
    p1b(i) = plot(time{i}(unlatchedIndex{i}),energyOutput{i}(unlatchedIndex{i}),...
        'Marker','o','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
    p1c(i) = plot(time{i}(takeoffIndex{i}),energyOutput{i}(takeoffIndex{i}),...
        'Marker','d','MarkerEdgeColor',plot_color,'MarkerFaceColor',[1 1 1]);
    %     legch(i) = cellstr(['$\delta_{L}$ = ',num2str(1000.*TimeDelay(i)),'ms']);
end
p1a_new = plot(10,10,'ok');
p1b_new = plot(10,10,'dk');
legend([p1a_new,p1b_new],{'unlatched','take-off'},'interpreter','latex','location','northwest');
yLim = ylim;
xlabel('Time $t$ (ms)','interpreter','latex');
if normalizecommand
    ylabel('Energy Output $\tilde{E}_{out}$','interpreter','latex');
    ylim([0 1.1]);
else
    ylabel('Energy Output $E_{out}$ (J)','interpreter','latex');
end
if (savecommand)
    fpath = strcat(pwd,'/timedelayplots/10152020');
    if normalizecommand  
        filename1 = ['AmpLatch_Normalized_Energy_Velocity'];
    else
        filename1 = ['GeoLatch_Energy_Velocity'];
    end
    saveas(gcf,fullfile(fpath,filename1),'svg');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'fig');
end

% plot - force
figure(5)
hold on; box on;
for i = 1:length(TimeDelay)
    p1(i) = plot(time{i}(1:takeoffIndex{i}),outputMisc{i}(1:takeoffIndex{i},1)./StartExtensorForce);
    legch(i) = cellstr(['$t_{\delta}$ = ',num2str(1000.*TimeDelay(i)),'ms']);
end
for i = 1:length(TimeDelay)
    p1b(i) = plot(time{i}(unlatchedIndex{i}),outputMisc{i}(unlatchedIndex{i},1)./StartExtensorForce,'og','MarkerSize',markerSize,'LineWidth',lineWidth);
    p1c(i) = plot(time{i}(takeoffIndex{i}),outputMisc{i}(takeoffIndex{i},1)./StartExtensorForce,'dm','MarkerSize',markerSize,'LineWidth',lineWidth);
end
yLim = ylim;
xlabel('Time $t$ (ms)','interpreter','latex');
ylabel('Latch Force $F_{latch}$ (N)','interpreter','latex');
legend([p1(:)',p1b(1),p1c(1)],{legch{:},'unlatched','take-off'},'interpreter','Latex','location','northeast');
ylim([0 1]);
set(gca, 'FontName', 'Calibri');
set(gca, 'FontSize', 17);   
set(gcf, 'Color', [1, 1, 1]);
if (savecommand)
    fpath = strcat(pwd,'/timedelayplots/10152020');
    if normalizecommand  
        filename1 = ['AmpLatch_Normalized_LatchForce_Velocity'];
    else
        filename1 = ['GeoLatch_LatchForce_Velocity'];
    end
    saveas(gcf,fullfile(fpath,filename1),'svg');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'fig');
end