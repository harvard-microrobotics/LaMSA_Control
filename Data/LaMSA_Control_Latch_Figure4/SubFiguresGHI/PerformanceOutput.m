
function [v_to,flag] = PerformanceOutput(input1,input2,input3)

% input1 = extensor offset angle (degrees)
% input2 = time delay (ms)
% input3 = initial flexion angle (degrees)

% outputs
% v_to   - take off velocity - m/s, 
% flag   - 1 if unlatched index > takeoff index, 0 otherwise.
% if flag is 1 it means the flexor force hasn't compleyed decayed yet, but
% take-off occured because the legs have expanded to 180. Is that possible? 

% plotflag
plotflag = false;

% Input System Parameters
unlatchingTime = 0e-3; % seconds
StartExtensorForce = 15; % N
StartStiffness = 14650; % N/m
Mass = 1.5e-3; % kg
TibiaLength = 22e-3; % m
FemurLength = 22e-3; %m
ExtensorMomentArm = 9.57e-4; %m 9.5e-4
FlexorMomentArm = 2e-3; %m
ExtensorOffset = input1; % degrees
FlexorOffset = 85; % degrees
InitialFlexionAngle = input3; % degrees
TimeDelay = input2; % seconds

% General Parameters
dt = 1e-6; % seconds
Endtime = 60e-3; % seconds

% solve grasshopper model to obtain leg angle, displacement, velocity
% and accelertion
    [outputParams,outputMisc] = GrasshopperModel_decay([unlatchingTime,...
        StartExtensorForce,StartStiffness,Mass,TibiaLength,FemurLength,...
        ExtensorMomentArm,FlexorMomentArm,ExtensorOffset,FlexorOffset,...
        InitialFlexionAngle,TimeDelay],[dt,Endtime]);
    time = outputParams.Data(:,1).*1000; % ms
    legAngle = real(outputParams.Data(:,2)); % degrees
    x = outputParams.Data(:,3).*1000; %mm
    velocity = real(outputParams.Data(:,4)); %m/s
    acceleration = real(outputParams.Data(:,5)); %m/s^2
    unlatchingIndex = outputParams.unlatchingIndex;
    unlatchedIndex = outputParams.unlatchedIndex;
    takeoffIndex = outputParams.takeoffIndex;
    flag1 = outputParams.tracker; % 1 if unlatchedIndex > takeoffIndex, 0 otherwise
    flag2 = outputParams.tracker2; % 1 if accleereration kink is seen (a goes < 0)
    v_to = velocity(takeoffIndex); % m/s
    
    % updating the value for flag variable
    % if flag is zero at the end, then the input points are feasible
    % if flag is not zero at the end, then the input points are infeasible
    flag = 0;
    
    if flag1 == 1
        flag = 1;
    end
    
    if flag == 0
        if flag2 == 1
            flag = 1;
        end
    end
    
    % check for take-off time
    time_to = time(takeoffIndex);
    
% plot definitions
lineWidth = 2.0; markerSize = 10; 

if (plotflag)
    % plot - Leg angle
    figure()
    hold on; box on;
    for i = 1:length(TimeDelay)
        p1(i) = plot(time,legAngle,'LineWidth',lineWidth);
        legch(i) = cellstr(['$t_{\delta}$ = ',num2str(1000.*TimeDelay(i)),'ms']);
    end
    for i = 1:length(TimeDelay)
     p1a(i) = plot(time(unlatchingIndex),legAngle(unlatchingIndex),'^g','MarkerSize',markerSize,'LineWidth',lineWidth);
     p1b(i) = plot(time(unlatchedIndex),legAngle(unlatchedIndex),'og','MarkerSize',markerSize,'LineWidth',lineWidth);
     p1c(i) = plot(time(takeoffIndex),legAngle(takeoffIndex),'dm','MarkerSize',markerSize,'LineWidth',lineWidth);
    end
    xlabel('Time $t$ (ms)','interpreter','latex');
    ylabel('Leg angle $\theta$ (degrees)','interpreter','latex');
    legend([p1(:)',p1a(1),p1b(1),p1c(1)],{legch{:},'start','unlatched','take-off'},'interpreter','Latex','location','northeast');
    set(gca, 'FontName', 'Calibri');
    set(gca, 'FontSize', 17);   
    set(gcf, 'Color', [1, 1, 1]);

    % plot - velocity
    figure()
    hold on; box on;
    for i = 1:length(TimeDelay)
        p1(i) = plot(time,velocity,'LineWidth',lineWidth);
        legch(i) = cellstr(['$t_{\delta}$ = ',num2str(1000.*TimeDelay(i)),'ms']);
    end
    for i = 1:length(TimeDelay)
        p1a(i) = plot(time(unlatchingIndex),velocity(unlatchingIndex),'^g','MarkerSize',markerSize,'LineWidth',lineWidth);
        p1b(i) = plot(time(unlatchedIndex),velocity(unlatchedIndex),'og','MarkerSize',markerSize,'LineWidth',lineWidth);
        p1c(i) = plot(time(takeoffIndex),velocity(takeoffIndex),'dm','MarkerSize',markerSize,'LineWidth',lineWidth);
    end
    xlabel('Time $t$ (ms)','interpreter','latex');
    ylabel('Velocity $v$ (m/s)','interpreter','latex');
    legend([p1(:)',p1a(1),p1b(1),p1c(1)],{legch{:},'start','unlatched','take-off'},'interpreter','Latex','location','northeast');
    set(gca, 'FontName', 'Calibri');
    set(gca, 'FontSize', 17);   
    set(gcf, 'Color', [1, 1, 1]);

    % plot - accln
    figure()
    hold on; box on;
    for i = 1:length(TimeDelay)
        p1(i) = plot(time,acceleration,'LineWidth',lineWidth);
        legch(i) = cellstr(['$t_{\delta}$ = ',num2str(1000.*TimeDelay(i)),'ms']);
    end
    for i = 1:length(TimeDelay)
        p1a(i) = plot(time(unlatchingIndex),acceleration(unlatchingIndex),'^g','MarkerSize',markerSize,'LineWidth',lineWidth);
        p1b(i) = plot(time(unlatchedIndex),acceleration(unlatchedIndex),'og','MarkerSize',markerSize,'LineWidth',lineWidth);
        p1c(i) = plot(time(takeoffIndex),acceleration(takeoffIndex),'dm','MarkerSize',markerSize,'LineWidth',lineWidth);
    end
    xlabel('Time $t$ (ms)','interpreter','latex');
    ylabel('Accln $a$ (ms$^{-2}$)','interpreter','latex');
    legend([p1(:)',p1a(1),p1b(1),p1c(1)],{legch{:},'start','unlatched','take-off'},'interpreter','Latex','location','northeast');
    set(gca, 'FontName', 'Calibri');
    set(gca, 'FontSize', 17);   
    set(gcf, 'Color', [1, 1, 1]);
end


end
