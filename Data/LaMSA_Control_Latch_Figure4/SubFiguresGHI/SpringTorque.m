    
function ST = SpringTorque(theta,localParams)

% localParams(1) = ExtensorMomentArm
% localParams(2) = ExtensorOffset
% localParams(3) = StartStiffness
% localParams(4) = StartSpringLength
% localParams(5) = ExtensorMomentArm
% localParams(6) = InitialFlexionAngle
% localParams(7) = ExtensorOffset

    ST = SpringForce(theta,localParams(3:end)) * SpringMomentArm(theta,[localParams(1),localParams(2)]);
    
end