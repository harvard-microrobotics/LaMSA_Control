%%%%
% Paper : "Spring and latch dynamics act as control pathways in ultrafast systems"
% 
% Description: Data for Figure 7. Transmission efficiency is enhanced through spring 
%              and latch properties, such that controllability and compensation of 
%              projectile velocity is achieved through cooperative negative feedback 
%              control of latch force limits and applied field in metamaterial springs.

close all;

Instantaneous_no_alpha = load('Data_fixed_meta_spring_1000_latch_mass_1_no_forcelimit_300vl_lb_3700no_alpha.mat');
slowpull_no_forcelimit_no_alpha = load('Data_fixed_meta_spring_1000_latch_mass_1_no_forcelimit_3000vl_lb_3200no_alpha.mat');
slowpull_with_forcelimit_no_alpha = load('Data_fixed_meta_spring_1000_latch_mass_1_with_forcelimit_3vl_lb_3200no_alpha.mat');
slowpull_with_forcelimit_with_alpha = load('Data_fixed_meta_spring_1000_latch_mass_1_with_forcelimit_3vl_lb_3200with_alpha_strain_700_v1.mat');
slowpull_with_forcelimit_with_alpha_delay = load('Data_fixed_meta_spring_1000_latch_mass_1_with_forcelimit_3vl_lb_3200with_alpha_strain_700_v1_delay_alpha_3.mat');

%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE Fig.6 I,J,K,L (Feedback control with delay)
%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:5
    
    if i==1
        Data(i) = Instantaneous_no_alpha;
    elseif i==2
        Data(i) = slowpull_no_forcelimit_no_alpha;
        
    elseif i==3
        Data(i) = slowpull_with_forcelimit_no_alpha;
        
    elseif i==4
        Data(i) = slowpull_with_forcelimit_with_alpha;
    elseif i==5
        Data(i) = slowpull_with_forcelimit_with_alpha_delay;    
        
    end
    params_MURI=Data(i).params_MURI;
    t = Data(i).t;
    x_sol = Data(i).x_sol;
    y_sol = Data(i).y_sol;
    dx_sol = Data(i).dx_sol;
    dy_sol = Data(i).dy_sol;
    T_switch = Data(i).T_switch;
    T_switch_ind = Data(i).T_switch_ind;
    T_switch_takeoff = Data(i).T_switch_takeoff;
    T_switch_takeoff_ind = Data(i).T_switch_takeoff_ind;
    F_sol = Data(i).F_sol;
    meta_alpha = Data(i).meta_alpha;
    
    figure(1000)
    subplot(2,2,2)
     hold on;
    if i==3
        plot(t(1:T_switch_ind),dy_sol(1:T_switch_ind), 'r','LineWidth',1.2);
        plot(t(T_switch_ind),dy_sol(T_switch_ind),'ro', 'MarkerFaceColor','r','MarkerSize', 6);
        xlabel('Time (ms)','FontSize',13)
        ylabel('Latch velocity m/s','FontSize',13)
    elseif i==4
        plot(t,dy_sol, 'r--','LineWidth',1.2);
        xlabel('Time (ms)','FontSize',13)
        ylabel('Latch velocity m/s','FontSize',13)
    elseif i==5
        plot(t(1:T_switch_ind),dy_sol(1:T_switch_ind), 'b','LineWidth',1.2);
        plot(t(T_switch_ind),dy_sol(T_switch_ind),'bo', 'MarkerFaceColor','b','MarkerSize', 6);
        xlabel('Time (ms)','FontSize',13)
        ylabel('Latch velocity m/s','FontSize',13)
    end
    if i==2 || i==4
    subplot(2,2,3)
    hold on;
    if i==2
        plot(t(1:T_switch_ind),F_sol(1:T_switch_ind), 'r--','LineWidth',1.2);
        plot(t(T_switch_ind),F_sol(T_switch_ind),'ro', 'MarkerFaceColor','r','MarkerSize', 6);

    elseif i==4
        plot(t(1:T_switch_ind),F_sol(1:T_switch_ind), 'b','LineWidth',1.2);
        plot(t(T_switch_ind),F_sol(T_switch_ind),'bo', 'MarkerFaceColor','b','MarkerSize', 6);
%   
    end
    ylim([-params_MURI.f_limit-6,params_MURI.f_limit+6])
    xlabel('Time (ms)','FontSize',13)
    ylabel('Force (N)','FontSize',13)
    end
    if i==5
        subplot(2,2,4)
        hold on;
        plot(t(1:T_switch_ind),meta_alpha(1:T_switch_ind)-0.5, 'b','LineWidth',1.2);
        
        plot(t(T_switch_ind),meta_alpha(T_switch_ind)-0.5,'bo', 'MarkerFaceColor','b','MarkerSize', 6);
        ylim([-0.8,0.5])
        xlabel('Time (ms)','FontSize',13)
        ylabel('External field \Delta\alpha','FontSize',13)
    end
    subplot(2,2,1)
    hold on;
    if i==3
        plot(t,dx_sol, 'r','LineWidth',1.2);
        plot(t(T_switch_ind),dx_sol(T_switch_ind),'ro', 'MarkerFaceColor','r','MarkerSize', 6);
        plot(T_switch_takeoff,dx_sol(T_switch_takeoff_ind),'rx', 'MarkerFaceColor','r','MarkerSize', 6);
        xlabel('Time (ms)','FontSize',13)
        ylabel('Projectile velocity m/s','FontSize',13)
    elseif i==4
        plot(t,dx_sol, 'r--','LineWidth',1.2);
        plot(t(T_switch_ind),dx_sol(T_switch_ind),'ro', 'MarkerFaceColor','r','MarkerSize', 6);
        plot(T_switch_takeoff,dx_sol(T_switch_takeoff_ind),'rx', 'MarkerFaceColor','r','MarkerSize', 6);
        xlabel('Time (ms)','FontSize',13)
        ylabel('Projectile velocity m/s','FontSize',13)
    elseif i==5
        plot(t,dx_sol, 'b-','LineWidth',1.2);
        plot(t(T_switch_ind),dx_sol(T_switch_ind),'bo', 'MarkerFaceColor','b','MarkerSize', 6);
        plot(T_switch_takeoff,dx_sol(T_switch_takeoff_ind),'bx', 'MarkerFaceColor','b','MarkerSize', 6);
        xlabel('Time (ms)','FontSize',13)
        ylabel('Projectile velocity m/s','FontSize',13)
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE Fig.6 B,C,D,E (TER with force limit)
%%%%%%%%%%%%%%%%%%%%%%%%%% 

for spring_number=1:2
Controllability_instantaneous_flag = 1;
fig_TER_analysis_flag =1;
spring_flag_analysis=spring_number;
    if spring_flag_analysis==1
            load('Loss_Tot_fixed_spring_1000_latch_mass_1_normalized_init_E_1_no_forcelimit_vl_lb_200.mat');

            num_spring_list_analysis =length(spring_list);

    else
            load('Loss_Tot_fixed_meta_spring_1000_latch_mass_1_normalized_init_E_1_no_forcelimit_vl_lb_200.mat');

            num_spring_list_analysis =length(a_r_list);

    end
    

    if fig_TER_analysis_flag ==1

    f_limit_index =[1,3,5,7];

    if Controllability_instantaneous_flag ==1
        for ii=1:num_spring_list_analysis
            for ll=1:length(f_limit_list)
                for kk=1:length(R_list) 
                    Loss_vl = real(squeeze(Loss_E(kk,:,ll,ii)));
                    [Loss_min(kk,ll,ii),Loss_min_index(kk,ll,ii)] = min(Loss_vl);

                    Controllability(kk,ll,ii) = real(squeeze(Loss_E(kk,1,ll,ii)-Loss_min(kk,ll,ii)));

                end
            end
        end
    else
        Controllability = real(squeeze(Loss_E(:,1,:,:)-Loss_E(:,end,:,:)));
    end
    Controllability_inst = real(squeeze(Loss_E(:,1,:,:)-Loss_E(:,end,:,:)));

    if spring_flag_analysis==1   
        [XX, YY] = meshgrid(R_list, spring_list+1);
        ylim_low = spring_list(1)+1;
        ylim_high = spring_list(end)+1;
        y_label = 'Spring exponent (n)';
        title_label = 'Polynomial';

    else
        [XX, YY] = meshgrid(R_list, a_r_list);
        ylim_low = a_r_list(1);
        ylim_high = a_r_list(end);
        y_label = 'Pore rate (a_r)';
        title_label = 'Metamaterial';
    end
    F = squeeze(Controllability(:,end,:))';
    F_limit_1 = squeeze(Controllability(:,f_limit_index(1),:))';
    F_limit_2 = squeeze(Controllability(:,f_limit_index(2),:))';
    F_limit_3 = squeeze(Controllability(:,f_limit_index(3),:))';

    figure(101)

    subplot(2,2,1+(spring_number-1)*2)
    contourf(XX,YY,F_limit_2);
    xlabel('Latch radius (R)','FontSize',13)
    ylabel(y_label,'FontSize',13)
    xlim([R_list(1),R_list(end)])
    ylim([ylim_low, ylim_high])
    cb=colorbar;
    caxis([0 1])
    if spring_flag_analysis==1
       title(strcat('Polynomial |F|< ',num2str(f_limit_index(2)), '(N)'), 'Fontsize', 13); 
    else
       title('Meta Material', 'Fontsize', 13);         
    end
    ylabel(cb,'TER','FontSize',13)
    
    axis square;


    % Controllabilitiy difference over different force limit
    subplot(2,2,2+(spring_number-1)*2)
    hold on;
    contourf(XX,YY,F-F_limit_2);
    xlabel('Latch radius (R)','FontSize',13)
    ylabel(y_label,'FontSize',13)
    xlim([R_list(1),R_list(end)])
    ylim([ylim_low, ylim_high])
    plot([5],[0.5],'wo','MarkerFaceColor','w','MarkerSize', 7); 
    cb=colorbar;
    caxis([0 1])
    
    ylabel(cb,'Loss of TER','FontSize',13)
    axis square;
    title(title_label,'FontSize',13);
    
    clear Controllability
    end
end

%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 7. G, H (Transmission efficiency and state space plot)
%%%%%%%%%%%%%%%%%%%%%%

gu = open('Figure_Feedback_TE.fig');
gu1 = open('Figure_Feedback_State_space2.fig');
% Now create destination graph
figure(5)
ax = zeros(2,1);
for i = 1:2
    ax(i)=subplot(2,1,i);
end
% Now copy contents of each figure over to destination figure
% Modify position of each axes as it is transferred

for i = 1:2
    figure(i)
    h = get(gcf,'Children');
    newh = copyobj(h,5)
    for j = 1:length(newh)
    posnewh = get(newh(j),'Position');
    possub  = get(ax(i),'Position');
    set(newh(j),'Position',...
    [posnewh(1) possub(2) posnewh(3) possub(4)])
    end
    delete(ax(i));
end

close(gu,gu1)