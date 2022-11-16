 
function MMA = MuscleMomentArm(theta,localParams)
% localParams(1) = FlexorMomentArm
% localParams(2) = FlexorOffset
MMA = localParams(1) * sind(theta + localParams(2));
end