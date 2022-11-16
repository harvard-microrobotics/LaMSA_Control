    
function MT = MuscleTorque(theta,localParams)

% localParams(1) = StartFlexorForce
% localParams(2) = FlexorMomentArm    
% localParams(3) = FlexorOffset
 
    if localParams(1)*MuscleMomentArm(theta,[localParams(2),localParams(3)]) > 0    
        MT = localParams(1)*MuscleMomentArm(theta,[localParams(2),localParams(3)]);       
    else
        MT = 0;    
    end
     
end
