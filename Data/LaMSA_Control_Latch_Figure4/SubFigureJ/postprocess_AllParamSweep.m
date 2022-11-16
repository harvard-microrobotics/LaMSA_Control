
clear all
clc
close all

tic;

% saveflag
savecommand = false;

% normalize data?
normalizecommand = true;

% input parameter arrays
% InitialFlexionAngleArray = [10,20,30,40,50,60]; % degrees
InitialFlexionAngleArray = 10; % degrees

% timedelay Array
timeDelay = [0.001,0.01,0.05,0.1,0.2,0.5:0.5:40].*1e-3; % seconds

% filepath and filenames
fpath = 'data/03102020/';
for i = 1:length(InitialFlexionAngleArray)
    % build filenames
    filename1 = ['maxVelocityMatrix_legAngle',num2str(InitialFlexionAngleArray(i))];
    filename1 = [fpath,filename1,'.csv'];
    filename2 = ['flagMatrix_legAngle',num2str(InitialFlexionAngleArray(i))];
    filename2 = [fpath,filename2,'.csv'];
    extensorOffsetAngleArray = [-(InitialFlexionAngleArray(i)-5):0.5:60].*-1;
    % read data stored in the files
    maxVelocityMatrix{i} = readmatrix(filename1);
    velocityMatrix = maxVelocityMatrix{i};
    energyMatrix = 0.5.*1.5e-3.*(velocityMatrix).^2;
    if normalizecommand
        velocityMatrix = velocityMatrix./3.04; % since 3.2m/s is grasshopper velocity
        energyMatrix = energyMatrix./(0.5.*1.5e-3.*3.04^2);
    end
    flagMatrix = readmatrix(filename2);
    [rowVec,colVec] = find(flagMatrix);

%     for j = 1:length(extensorOffsetAngleArray)
%         for k = 1:length(timeDelay)
%             if flagMatrix{i}(k,j) == 1
%                 velocityMatrix(k,j) = nan;
%             end
%         end
%     end
    
    % plot

end

% figure(1)
% box on; hold on;
% p1 = imagesc(extensorOffsetAngleArray',1000.*timeDelay',velocityMatrix);
% xlabel('$\phi_{ext}$ ($^\circ$)','Interpreter','latex');   
% ylabel('$t_{L} (ms)$','Interpreter','latex');    
% xlim([min(extensorOffsetAngleArray) max(extensorOffsetAngleArray)]);
% ylim([min(timeDelay*1000) max(timeDelay*1000)]);
% colorBarProps = colorbar;
% colorTitleHandle = get(colorBarProps,'Title');
% caxis([0 3.2]);   
% titleString = ['$v_{to}$ (m/s)'];
% title(['($\theta_{init}$ = ',num2str(InitialFlexionAngleArray),'$^\circ$)'],'interpreter','Latex');
% set(colorTitleHandle ,'String',titleString,'interpreter','Latex');
% set(gca, 'FontName', 'Calibri');
% set(gca, 'FontSize', 17);   
% set(gcf, 'Color', [1, 1, 1]);
% 
% figure(2)
% box on; hold on;
% p1 = imagesc(extensorOffsetAngleArray',1000.*timeDelay',flagMatrix);
% xlabel('$\phi_{ext}$ ($^\circ$)','Interpreter','latex');   
% ylabel('$t_{L} (ms)$','Interpreter','latex');    
% xlim([min(extensorOffsetAngleArray) max(extensorOffsetAngleArray)]);
% ylim([min(timeDelay*1000) max(timeDelay*1000)]);
% colorBarProps = colorbar;
% colorTitleHandle = get(colorBarProps,'Title');
% titleString = ['$v_{to}$ (m/s)'];
% title(['($\theta_{init}$ = ',num2str(InitialFlexionAngleArray),'$^\circ$)'],'interpreter','Latex');
% set(colorTitleHandle ,'String',titleString,'interpreter','Latex');
% set(gca, 'FontName', 'Calibri');
% set(gca, 'FontSize', 17);   
% set(gcf, 'Color', [1, 1, 1]);
% 
% fig3 = figure(3)
% hold on;
% p1 = imagesc(extensorOffsetAngleArray',1000.*timeDelay',energyMatrix);
% xlabel('Extensor offset $\phi_{ext}$ ($^\circ$)','Interpreter','latex');   
% ylabel('Time delay $t_{L} (ms)$','Interpreter','latex');    
% xlim([min(extensorOffsetAngleArray) max(extensorOffsetAngleArray)]);
% ylim([min(timeDelay*1000) max(timeDelay*1000)]);
% % colormap(copper(10000));
% colorBarProps = colorbar;
% colorTitleHandle = get(colorBarProps,'Title');
% colormap(brewermap(20,'YlGnBu'))
% if normalizecommand
%     caxis([0 1]);  
%     titleString = ['$\tilde{E}_{out}$'];
% else
%     caxis([0 3.2]); 
%     titleString = ['$E_{out}$ (J)'];
% end
% 
% for i = 1:length(extensorOffsetAngleArray)
%     for j = 1:length(timeDelay)
%         if flagMatrix(j,i) == 1
%             plot(extensorOffsetAngleArray(i),1000.*timeDelay(j),'w.','MarkerSize',12,'LineWidth',2.0);
%         end
%     end
% end
% fig3.Renderer = 'painter';
% % title(['($\theta_{init}$ = ',num2str(InitialFlexionAngleArray),'$^\circ$)'],'interpreter','Latex');
% set(colorTitleHandle ,'String',titleString,'interpreter','Latex');
% % a = 1; b = 3;
% % x = -a:0.1:a;
% % y = sqrt(b^2 - b^2*(x.^2/a^2));
% % p1 = fill(x,y,'r');
% % p1.LineWidth = 2;
% % p1.EdgeColor = 'r';
% % p1.FaceAlpha = 0.4;
% % p1.EdgeAlpha = 0;
% % p2 = plot([5:-0.01:0],1.25.*ones(length([5:-0.01:0]),1),'--k','LineWidth',2);
% % p3 = plot(zeros(length([1.25:0.01:40]),1),[1.25:0.01:40],'--k','LineWidth',2);
% box on;
% set(gca, 'FontName', 'Calibri');
% set(gca, 'FontSize', 17);   
% set(gcf, 'Color', [1, 1, 1]);
% set(gca, 'XDir','reverse');
% set(gca, 'YDir','reverse');

figs = figure(4)
hold on;
p1 = contourf(extensorOffsetAngleArray,1000.*timeDelay,energyMatrix,100,'LineStyle','None');
colormap(copper(10000));
xlabel('Extensor offset $\phi_{ext}$ ($^\circ$)','Interpreter','latex');   
ylabel('Time delay $t_{L} (ms)$','Interpreter','latex');  
set(gca, 'XDir','reverse');
set(gca, 'YDir','reverse');
for i = 1:length(extensorOffsetAngleArray)
    for j = 1:length(timeDelay)
        if flagMatrix(j,i) == 1
            plot(extensorOffsetAngleArray(i),1000.*timeDelay(j),'wo','MarkerSize',12,'MarkerFaceColor','w','LineWidth',2.0);
        end
    end
end
figs.Renderer = 'painter';
colorBarProps = colorbar;
colorTitleHandle = get(colorBarProps,'Title');
c2Label = xlabel(colorBarProps, '$\tilde{E}_{out}$','interpreter','Latex');
if normalizecommand
    caxis([0 1]);  
    titleString = ['$\tilde{E}_{out}$'];
else
    caxis([0 3.2]); 
    titleString = ['$E_{out}$ (J)'];
end
colormap(brewermap(20,'YlGnBu'));
set(colorTitleHandle ,'String',titleString,'interpreter','Latex');
set(gca, 'FontName', 'Calibri');
set(gca, 'FontSize', 17);   
set(gcf, 'Color', [1, 1, 1]);


toc;


