function [dk]=de2dk(E0,dE,theta_i,theta_tot)
theta_i=theta_i.*pi/180;
theta_tot=theta_tot.*pi/180;
load_chess_parameters;
K0=beamprops('energy',E0,3);
theta_f=theta_tot-theta_i;
kf=beamprops('energy',E0+dE,3);
dk=kf.*sin(theta_f)-(K0.*sin(theta_i));
end