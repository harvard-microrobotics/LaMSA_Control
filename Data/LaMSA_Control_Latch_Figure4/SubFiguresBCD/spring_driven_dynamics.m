function [t x v a F] = spring_driven_dynamics(d,L,K,R,v_L,m,m_s)

% xmax = min([Fmax*L/(E*A) d sigma_f*L/E]);
xmax = d;
omega = sqrt((K)/(m+m_s));
tau_L = R/v_L;

t = [];
x = [];
v = [];
a = [];
F = [];

N = 10000; % resolution of t-grid

%% in contact with the latch
if (R>=xmax*(omega*tau_L)^2)
    t_l = 0;   %% instantaneous latch release
    x_l = 0;
    v_l = 0;
    idx = 1;
else
    ts = linspace(0,tau_L,N)';
    f = (xmax/R-1)*(1-(ts/tau_L).^2).^1.5+(1-(ts/tau_L).^2).^2-1/(omega*tau_L)^2;
    idx = find(f<0,1,'first');
    t_l = ts(idx);
    t = [t; ts(1:idx)];
    x = [x; R*(1-sqrt(1-(ts(1:idx)/tau_L).^2))];
    v = [v; (R/tau_L)*(ts(1:idx)/tau_L)./sqrt(1-(ts(1:idx)/tau_L).^2)];
    a = [a; (R/tau_L^2)*(1-(ts(1:idx)/tau_L).^2).^(-1.5)];
    x_l = x(end);
    v_l = v(end);
end

%% unconstrained dynamics after latch release
v_to = sqrt(omega^2*(xmax-x_l)^2 + v_l^2);
phi = acos(omega*(xmax-x_l)/v_to)-omega*t_l;
t_to = (pi/2-phi)/omega;
ts = linspace(t_l,t_to,N)';
t = [t; ts];
x = [x; xmax-(v_to/omega)*cos(omega*ts+phi)];
v = [v; v_to*sin(omega*ts+phi)];
a = [a; omega*v_to*cos(omega*ts+phi)];
F = m*a;
global params;
params = [t_l,idx];
end
