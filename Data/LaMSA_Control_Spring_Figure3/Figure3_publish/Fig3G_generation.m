%% calculate the recoil velocity with different strengths of fields

clear
clc

% color map
load('V_strain0p3.mat')
load('Dissipation_strain0p3.mat')

V_strain0p3s=smooth(V_strain0p3);
Dissipation_strain0p3s=smooth(smooth(smooth(Dissipation_strain0p3)));
ar_0p3=0.01:0.01:1;
ar_0p3_int=0.01:0.001:1;
V_strain0p3_int=interp1(ar_0p3,V_strain0p3s,ar_0p3_int);
Dissipation_strain0p3_int=interp1(ar_0p3,Dissipation_strain0p3s,ar_0p3_int);

alpha_0p3=0:0.004:2;

for i=1:numel(ar_0p3_int)
    for j=1:numel(alpha_0p3)
         V_alpha_strain0p3(i,j)=V_strain0p3_int(i)*sqrt(1+alpha_0p3(j)/Dissipation_strain0p3_int(i));
         Dissipation_alpha_strain0p3(i,j)=(Dissipation_strain0p3_int(i)+alpha_0p3(j))/(1+alpha_0p3(j));
    end
end

figure(1)
pcolor(ar_0p3_int,alpha_0p3,V_alpha_strain0p3')
title(sprintf('Recoil Velocity'));
shading flat
axis tight
box on
caxis([0,0.2])
colormap(brewermap(20,'YlGnBu'))

figure(2)
pcolor(ar_0p3_int,alpha_0p3,Dissipation_alpha_strain0p3')
title(sprintf('Dissipationin spring'));
shading flat
axis tight
box on
caxis([0,1])
colormap(brewermap(20,'YlGnBu'))