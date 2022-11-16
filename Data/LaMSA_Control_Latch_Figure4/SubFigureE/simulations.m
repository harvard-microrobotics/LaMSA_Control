% Function that simulates a contact-based LaMSA system for the given
% parameters and solves for the take-off velocity of the mass and the
% unlatching time (time-delay).
function [v_to_sim,t_l] = simulations(m,m_s,k,R,L,d,v_L)
    
    % m: projectile mass in g
    % d: spring compression in mm
    % L: spring length in mm
    % k: spring stiffness in N/m
    % R: latch radius in mm
    % v_L_start: latch release velocity at unlatching start in m/s
    % v_L_end: latch release velocity at unlatching end in m/s
   
    global params;
    v_L_mean = v_L; % avg
%     t_latch = 1e-3.*R./v_L_mean; %seconds
%     a_L = (v_L_end - v_L_start)/t_latch;

    % spring mass
%     m_s = 2.25/3; %g 
    
    % running simulations
    [t_s x_s v_s a_s F_s] = spring_driven_dynamics(d,L,k,R*1e-3,v_L,m*1e-3,m_s*1e-3);
    t_l = params(1); % unlatching time
    idx = params(2); % index
    v_to_sim = real(v_s(end));
end

