function Torsion_Lab
%%%
%%% -- Setup -- %%%
%%%
%mass added to pulley in g
load = [20,40,60,80,100,120];

%Diameter & length of shaft
D = .125; %in.
L = 23.75; %in.

% Angular displacement data in degrees
ss = [1.5,3.1,4.5,6.1,7.6,9.2];
ss_off = 0;
al = [4.1,8.3,12.6,16.4,20.4,24.7];
al_off = 0;
br = [3.3,6.5,9.6,12.7,15.8,18.8];
br_off = -.1;

%%%
%%% -- Initial Calcs -- %%%
%%%
% Vectors of angular displacement in radians accounting for offset
ss = deg_to_rad(offset(ss,ss_off));
al = deg_to_rad(offset(al,al_off));
br = deg_to_rad(offset(br,br_off));

%%% Error in measurement of the DLAG
del_p = deg_to_rad(.05);

%%% Vector of force computed from loads applied
T = applied_torque(load);


%%%
%%% -- Plotting Torque vs Angular Displacement -- %%%
%%%
[m_ss,m_al,m_br] = plot_data(ss,al,br,T,del_p);

%Display the polar moment of inertia
J = polar_moment(D);

% Calculate the modulus
[G_ss,G_al,G_br] = modulus(J,L,m_ss,m_al,m_br);



function [G_ss,G_al,G_br] = modulus(J,L,m_ss,m_al,m_br)
G_ss = m_ss * L / J;
G_al = m_al * L / J;
G_br = m_br * L / J;

fprintf('G for SS: %.2f\nG for Al: %.2f\nG for br: %.2f\n',G_ss,G_al,G_br)

function pol = polar_moment(D)
pol = pi*D^4/32;
fprintf('The polar moment of inerita is: %.3e\n',pol)

function [m_ss,m_al,m_br] = plot_data(ss,al,br,T,del_p)
figure('Name','Angle of Rotation vs Torque Applied')
plot(ss,T,'r+',al,T,'go',br,T,'b*')

%Uncertainty dots
hold on
plot(ss+del_p,T,'k.',ss-del_p,T,'k.',al+del_p,T,'k.',al-del_p,T,'k.',br+del_p,T,'k.',br-del_p,T,'k.','HandleVisibility','off','MarkerSize',9)

% linear fit for steel
lin_ss = fitlm(ss,T,'linear');
b_ss = table2array(lin_ss.Coefficients(1,'Estimate'));
m_ss = table2array(lin_ss.Coefficients(2,'Estimate'));
ss_fit = ss .* m_ss + b_ss;

% linear fit for aluminum
lin_al = fitlm(al,T,'linear');
b_al = table2array(lin_al.Coefficients(1,'Estimate'));
m_al = table2array(lin_al.Coefficients(2,'Estimate'));
al_fit = al .* m_al + b_al;

% linear fit for brass
lin_br = fitlm(br,T,'linear');
b_br = table2array(lin_br.Coefficients(1,'Estimate'));
m_br = table2array(lin_br.Coefficients(2,'Estimate'));
br_fit = br .* m_br + b_br;

% plotting the linear fits
hold on
plot(ss,ss_fit,'r',al,al_fit,'g',br,br_fit,'b')

% Plot tweaks
ss_leg = sprintf('T_s_s=%.2f\\phi+%.3f',m_ss,b_ss);
al_leg = sprintf('T_a_l=%.2f\\phi+%.3f',m_al,b_al);
br_leg = sprintf('T_b_r=%.2f\\phi+%.3f',m_br,b_br);
legend('304 SS','2011-T3 Al','360 Brass',ss_leg,al_leg,br_leg,'Location','northwest')
ylim([0 max(T)+.1])
xlim([0 max([ss,al,br]+.025)])
ylabel('Torque (in-lb)')
xlabel('\phi (radians)')
title('T vs \phi')

fprintf('The Spring Constants are as follows:\nSS: %.3f\nAl: %.3f\nBr: %.3f\n',m_ss,m_al,m_br)

function torque = applied_torque(load)
force = load ./ 1000 .* 9.8 .* .224808943;
torque = force .* (11.875/2);

function out = offset(vec,off)
out = vec - off;

function rad = deg_to_rad(deg)
rad = deg .* pi ./ 180;








