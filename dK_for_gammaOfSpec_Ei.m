% dK = dK_for_gammaOfSpec_Ei(Ei, gammaOffSpec, tot_angle)
% 
% Returns the dK for an offSpec gamma value.
%
% Ei           - incident energy (meV)
% gammaOffSpec - distance away from specular (degrees)
% tot_angle    - (optional) total scattering angle, if not 44.4 (degrees)
%
% dK - parallel momentum transfer (A^-1)
function dK = dK_for_gammaOfSpec_Ei(Ei, gammaOffSpec, tot_angle)

if ~exist('tot_angle','var')
    tot_angle=44.4;
end

[dK,dkz] = k_xfer(beamprops('energy',Ei,3),gammaOffSpec+tot_angle/2,tot_angle);

end
