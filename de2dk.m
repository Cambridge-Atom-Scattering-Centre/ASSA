% [dk]=de2dk(E0,dE,theta_i,theta_tot)
% 
% Calculate a parallel momentum transfer (delta k) from an energy change
% (delta E) for a specific incident angle and incident energy.
%
% E0 - incident energy (meV)
% dE - energy transfer (meV)
% theta_i - incident angle (degrees)
% theta_tot - total scattering angle (degrees)
%
% dk - parallel momentum transfer (A^-1)
function [dk]=de2dk(E0,dE,theta_i,theta_tot)
theta_i=theta_i.*pi/180;
theta_tot=theta_tot.*pi/180;
load_chess_parameters;
m = SE_amu * 3.01603;
K0=beamprops('energy',E0,3);
theta_f=theta_tot-theta_i;
kf=beamprops('energy',E0+dE,3);
dk=kf.*sin(theta_f)-(K0.*sin(theta_i));
return