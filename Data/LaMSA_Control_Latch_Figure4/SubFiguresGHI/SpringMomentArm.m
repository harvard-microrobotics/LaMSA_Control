    
function SMA = SpringMomentArm(theta,localParams)

% localParams(1) = ExtensorMomentArm
% localParams(2) = ExtensorOffset

SMA = localParams(1) * sind(theta - localParams(2));

end