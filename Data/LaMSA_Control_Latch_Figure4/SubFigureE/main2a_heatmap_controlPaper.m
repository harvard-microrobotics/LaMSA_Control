% Code to generate Figure 4c and 4d of the paper. 
% The script generates enough simulation data points to plot imagesc plots
% with colormaps.

clear all
clc
close all

tic;

new_fig =@()figure();
format long g;

% save the data as mat file?
filesavecommand = true;

% normalize command ?
normalizecommand = true;

% system parameters
k = 1000; %N/m
mass = 1; %g 
mass_spring = 0; %g
deltaX = 10;
SpringLength = deltaX;
% v_L_slow = 0.1.*sqrt(9.*0.001.*10.*0.001.*k./((mass+mass_spring).*0.001));
% v_L_fast = 1.10.*sqrt(9.*0.001.*10.*0.001.*k./((mass+mass_spring).*0.001)); % 14 is for 1g, 2 is for 50g
v_L_slow = 0.1;

% latch props;
latchRadii = [0.001,0.1:0.1:10];
latchRadii2 = [0.001,0.1:0.1:9];
latchVel = [0.01,0.05,0.1:0.01:10.0]; 

% global inputs
savecommand = false;

for i = 1:length(latchRadii)
    parfor j = 1:length(latchVel)
        [i,j]
        [v_to_sim(i,j),t_unl_sim(i,j)] = simulations(mass,mass_spring,k,latchRadii(i),SpringLength*1e-3,deltaX*1e-3,latchVel(j));
        energyOutput(i,j) = 0.5.*(mass + mass_spring).*1e-3.*v_to_sim(i,j).^2;
    end
%     energyOutput(i,j) = 0.5.*(mass + mass_spring).*1e-3.*v_to_sim(i,j).^2;
end
for i = 1:length(latchRadii2)
     v_trans(i) = sqrt(deltaX*1e-3.*latchRadii2(i).*1e-3.*k./((mass+mass_spring).*1e-3));
end
if normalizecommand 
    v_recoil = deltaX*0.001.*sqrt(k./(mass*1e-3)); % m/s
    v_to_sim = v_to_sim./v_recoil;
    latchRadii = latchRadii./deltaX;
    latchRadii2 = latchRadii2./deltaX;
    latchVel = latchVel./v_recoil;
    v_trans = v_trans./v_recoil;
    energyOutput = energyOutput./(0.5.*k.*(deltaX.*0.001).^2);
end

filename = strcat(['energyOutput_MegaSimData.mat']);
save(filename,'energyOutput');
filename = strcat(['takeoffVel_MegaSimData.mat']);
save(filename,'v_to_sim');
filename2 = strcat('latchRadii_MegaSimData.mat');
save(filename2,'latchRadii');
filename3 = strcat('latchVel_MegaSimData.mat');
save(filename3,'latchVel');
filename4 = strcat('v_trans_MegaSimData.mat');
save(filename4,'v_trans');
filename5 = strcat('unlatchingTime_MegaSimData.mat');
save(filename5,'t_unl_sim');
filename6 = strcat('latchRadii2_MegaSimData.mat');
save(filename6,'latchRadii2');


% single hue - 6 blues - http://colorbrewer2.org/#type=sequential&scheme=Blues&n=6
clrs_b = [8,81,156;49,130,189;107,174,214;158,202,225;198,219,239;239,243,255]./255;
% single hue - 6 Green and Blue - http://colorbrewer2.org/#type=sequential&scheme=GnBu&n=6
clrs_gb = [8,104,172;67,162,202;123,204,196;168,221,181;204,235,197;240,249,232]./255;
plotMarkers = {'o','+','*','.','x','s','d','^','>','<','p','h'};
lineWidth = 2.5;
markerSize = 10;

%% money plots - takeoff velocity
% loading all data
energyOutput_MegaSimData = load('energyOutput_MegaSimData.mat');
takeoffVel_MegaSimData = load('takeoffVel_MegaSimData.mat');
latchRadii_MegaSimData = load('latchRadii_MegaSimData.mat');
latchRadii2_MegaSimData = load('latchRadii2_MegaSimData.mat');
latchVel_MegaSimData = load('latchVel_MegaSimData.mat');
v_trans_MegaSimData = load('v_trans_MegaSimData.mat');
unlatchingTime_MegaSimData = load('unlatchingTime_MegaSimData.mat');
% converting unlatching time to millisecond
unlatchingTime_MegaSimData.t_unl_sim = unlatchingTime_MegaSimData.t_unl_sim.*1000;
% obtaining indices of all points where latch vel is less than transition velocity
indices = find(v_trans_MegaSimData.v_trans <= max(latchVel_MegaSimData.latchVel)); 
latchRadii2_MegaSimData.trans_indices = latchRadii2_MegaSimData.latchRadii2(indices);
v_trans_MegaSimData.trans_indices = v_trans_MegaSimData.v_trans(indices);
% latchVel_MegaSimData.trans_indices = latchVel_MegaSimData.latchVel(indices);
% obtaining data limits
% clims = [min(min(takeoffVel_MegaSimData.v_to_sim)) 0.9999.*max(max(takeoffVel_MegaSimData.v_to_sim))];
% creating alpha data matrix for transparency
alphaArray = zeros(size(takeoffVel_MegaSimData.v_to_sim));
[row,column] = size(takeoffVel_MegaSimData.v_to_sim);
% normalizing the alpha array 
alphaArray = takeoffVel_MegaSimData.v_to_sim./max(max(takeoffVel_MegaSimData.v_to_sim));
% define scaling factor
k = 0.50; % if not flipping teal color, then set this value to 0.80
% scaling the alpha matrix
alphaArray = k.*alphaArray;
% anything above transition limit should be 1 (i.e. max vel or switch behavior)
alphaInd = find(takeoffVel_MegaSimData.v_to_sim(:,:)==max(max(takeoffVel_MegaSimData.v_to_sim)));
alphaArray(alphaInd) = 0.70;
clims = [min(min(takeoffVel_MegaSimData.v_to_sim)) 14.321];


%%%%%%%%%%%%%%%%%%%%%%%%%    Making the colormap    %%%%%%%%%%%%%%%%%%%%%%
figure()
hold on; box on;
im_v_to = imagesc(latchRadii_MegaSimData.latchRadii',latchVel_MegaSimData.latchVel',takeoffVel_MegaSimData.v_to_sim'); 
box on;
% loading the desired colormap
% cmap_option = 'teals';
% cmap_fpath = 'colors/';
% cmap_fullfile = strcat(cmap_fpath,cmap_option);
% cmap_new = load(strcat(cmap_fullfile,'.dat'));
% % normalizing the colormap
% cmap_new = (cmap_new./255);
% [m,n] = size(cmap_new);
% cbar2 = colorbar;
% applying colormap
% cmap_new = flipud(cmap_new);
colormap(copper(10000));
imlim2 = caxis;
c = colorbar();
% Manually flush the event queue and force MATLAB to render the colorbar
% necessary on some versions
% drawnow
% alphaVal = 0.85;
% % Get the color data of the object that correponds to the colorbar
% cdata = c.Face.Texture.CData;
% % Change the 4th channel (alpha channel) to 10% of it's initial value (255)
% cdata(end,:) = uint8(alphaVal * cdata(end,:));
% % Ensure that the display respects the alpha channel
% c.Face.Texture.ColorType = 'truecoloralpha';
% % Update the color data with the new transparency information
% c.Face.Texture.CData = cdata;
% % adding transition velocity line to the plot
if ~normalizecommand
    plot_trans = plot(latchRadii2, v_trans,'-k','LineWidth',2.5);
end
% plot_trans = plot(transpose(latchRadii2_MegaSimData.trans_indices(1:end)),transpose(v_trans_MegaSimData.trans_indices(1:end)),'-k','LineWidth',2.5);
% plot_slowvel = plot(latchRadii2_MegaSimData.latchRadii2', v_L_slow.*ones(length(latchRadii2_MegaSimData.latchRadii2'),1),'--','LineWidth',2.5);
% plot_fastvel = plot(latchRadii2_MegaSimData.latchRadii2', v_L_fast.*ones(length(latchRadii2_MegaSimData.latchRadii2'),1),'-','LineWidth',2.5);
% plot_slowvel_markers = plot([0,3,5,7,9], v_L_slow,'--o','MarkerSize',markerSize,'LineWidth',lineWidth);
% plot_fastvel_markers = plot([0,3,5,7,9], v_L_fast,'-o','MarkerSize',markerSize,'LineWidth',lineWidth);
ylim([latchVel_MegaSimData.latchVel(1) latchVel_MegaSimData.latchVel(end)]);
xlim([latchRadii_MegaSimData.latchRadii(1) latchRadii_MegaSimData.latchRadii(end)]);
% xlim([0 9]);
box on;
if normalizecommand
     ylabel('Latch velocity $\tilde{v}_{L}$','interpreter','Latex');
     xlabel('Latch radius $\tilde{R}$','interpreter','Latex');
     titlechar = ['$\tilde{E}_{out}$'];
else
    ylabel('Latch velocity $v_{L}$ (m/s)','interpreter','Latex');
    xlabel('Latch radius $R$ (mm)','interpreter','Latex');
    titlechar = ['$E_{J}$','(J)'];
end
% title('Take-off Velocity $v_{to}$(m/s)','interpreter','Latex');
title(c,titlechar,'interpreter','Latex');
if (savecommand)
    fpath = strcat(pwd,'/plots');
    if normalizecommand
        filename1 = strrep(['ContactLatch_Normalized_Heatmap'],'.','p');
    else
        filename1 = strrep(['ContactLatch_Heatmap'],'.','p');
    end
    saveas(gcf,fullfile(fpath,filename1),'svg');
    saveas(gcf,fullfile(fpath,filename1),'png');
    saveas(gcf,fullfile(fpath,filename1),'fig');
    saveas(gcf,fullfile(fpath,filename1),'epsc');
end


figs = figure(4)
hold on;
p1 = contourf(latchRadii_MegaSimData.latchRadii',latchVel_MegaSimData.latchVel',takeoffVel_MegaSimData.v_to_sim'.^2,1000,'LineStyle','None');
% colormap(copper(10000));
color_map1 = brewermap(20,'YlGnBu');
colormap(gcf,color_map1);
ylabel('Latch velocity $\tilde{v}_{L}$','interpreter','Latex');
xlabel('Latch radius $\tilde{R}$','interpreter','Latex');
figs.Renderer = 'painter';
colorBarProps = colorbar;
c2Label = xlabel(colorBarProps, '$\tilde{E}_{out}$','interpreter','Latex'); 
set(gcf, 'Color', [1, 1, 1]);
ylim([latchVel_MegaSimData.latchVel(1) latchVel_MegaSimData.latchVel(end)]);
xlim([latchRadii_MegaSimData.latchRadii(1) latchRadii_MegaSimData.latchRadii(end)]);

toc;
