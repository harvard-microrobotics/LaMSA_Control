    
function LA = LegAngle(x,localParams)
% localParams = FemurLength
LA = 2*asind(x/(2*localParams));
end
