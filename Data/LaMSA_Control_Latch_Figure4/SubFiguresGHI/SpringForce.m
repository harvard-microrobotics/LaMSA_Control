    
function SF = SpringForce(theta,localParams)
% localParams(1) = StartStiffness
% localParams(2) = StartSpringLength
% localParams(3) = ExtensorMomentArm
% localParams(4) = InitialFlexionAngle
% localParams(5) = ExtensorOffset

    if localParams(1)*(localParams(2) - SpringExcursion(theta,[localParams(3),localParams(4),localParams(5)])) > 0
        SF = localParams(1)*(localParams(2) - SpringExcursion(theta,[localParams(3),localParams(4),localParams(5)]));
    else
        SF = 0;
    end

end
