
function SE = SpringExcursion(theta,localParams)

% localParams(1) = ExtensorMomentArm
% localParams(2) = InitialFlexionAngle
% localParams(3) = ExtensorOffset

SE = (localParams(1) * cosd(localParams(2) - localParams(3))...
            - localParams(1) * cosd(theta - localParams(3)));
end