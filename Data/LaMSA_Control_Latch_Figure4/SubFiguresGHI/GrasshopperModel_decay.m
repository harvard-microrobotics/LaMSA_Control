% Translation of Greg's model from Mathematica to Maltab
%
% A grasshopper jump kinetic model based on bennet-clark 1975 and
% Heitler 1977  - modelling a Male locust
% Obtained from Ryan (author of this script) on 01/30/2020

% Modified by Sathvik on 02/04/2020

function [outputParams,outputMisc] = GrasshopperModel_decay(SysParams,GenParams)

% Params
unlatchingTime = SysParams(1); % seconds
StartExtensorForce = SysParams(2); % N
StartStiffness = SysParams(3); % N/m
Mass = SysParams(4); % kg
TibiaLength = SysParams(5); % m
FemurLength = SysParams(6); %m
ExtensorMomentArm = SysParams(7); %m
FlexorMomentArm = SysParams(8); %m
ExtensorOffset = SysParams(9); % degrees
FlexorOffset = SysParams(10); % degrees
InitialFlexionAngle = SysParams(11); % degrees
t_delta = SysParams(12);

% global variables
% global ExtensorMomentArm InitialFlexionAngle ExtensorOffset...
%     FlexorMomentArm FlexorOffset StartStiffness StartSpringLength...
%     StartFlexorForce FemurLength

% StartStiffness = 1/2 * 15 * 15 / (0.00768); %N/m
% keyed to get a take-off energy of 3.2 m/s, as in Bennet-Clark

StartSpringLength = StartExtensorForce/StartStiffness; %m

%ExtensorMomentArm = 0.37e-3 * TibiaLength/.0085; %m
% Extensor Moment Arm in m from Heitler 1977- which needs to be scaled up
% for Bennet-Clarks animal.  Heitlers animal had a tibia length of 8.5 mm, 
% while bennet-clarks animal had a length of 22 mm

%ExtensorOffset = 0; %deg
% The number of degrees off of the tibia that the exensor moment arm is 
% offset - see subsequent drawing

%FlexorMomentArm = 0.77e-3 * TibiaLength/.0085; %m
% Flexor Moment Arm in m from Heitler 1977  - which need to  be 
% scaled up for Bennet-Clarks animal.  Heitlers animal had a tibia 
% length of 8.5 mm, while bennet-clarks animal had a length of 22 mm
% 9/24/19 - this scaling factor (* TibiaLength/.0085;) was not in the
% original code provided by Greg, need clarification

%FlexorOffset = 85; %deg
% the number of degrees off of the tibia that the flexor moment arm is 
% offset - see subsequent drawing

%InitialFlexionAngle = 5; %deg
% the initial position of the leg

%Target Variables
DesiredTakeOffVelocity = 3.2  ;% take off velocity in m/s 
DesiredOutputEnergy = 1/2 * Mass * DesiredTakeOffVelocity^2;

StartFlexorForce = (StartExtensorForce*...
    (SpringMomentArm(InitialFlexionAngle,[ExtensorMomentArm,ExtensorOffset]))/MuscleMomentArm(InitialFlexionAngle,[FlexorMomentArm,FlexorOffset]));

InitialPosition = 2*FemurLength*sind(InitialFlexionAngle/2);

% set up forward dynamics model
dt = GenParams(1); % 1e-6 seconds
Endtime = GenParams(2); % 6e-2 seconds

%dt=1e-6;
%Endtime=0.06;
time(1,1)=0;
dxdt(1,1)=0;
x(1,1)=InitialPosition;

for index=1:Endtime/dt
     
    if time(index)>unlatchingTime 
        if time(index) <= unlatchingTime + t_delta % latch delay, force decays at prescribed rate
            temp=LegAngle(x(index,1),FemurLength);
            FlexorForce(index,1) = (1 - (time(index) - unlatchingTime)/t_delta)*StartFlexorForce;
            FlexorTorque(index,1) = (1 - (time(index) - unlatchingTime)/t_delta)*MuscleTorque(LegAngle(x(index,1),FemurLength),[StartFlexorForce,FlexorMomentArm,FlexorOffset]);
            springTorque(index,1) = SpringTorque(temp,[ExtensorMomentArm,ExtensorOffset,StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset]);
            springMomentArm(index,1) = SpringMomentArm(temp,[ExtensorMomentArm,ExtensorOffset]);
            springForce(index,1) = SpringForce(temp,[StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset]);
            ddxddt(index,1)=(SpringTorque(temp,[ExtensorMomentArm,ExtensorOffset,StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset])-(1-(time(index)-unlatchingTime)/t_delta)*MuscleTorque(LegAngle(x(index,1),FemurLength),[StartFlexorForce,FlexorMomentArm,FlexorOffset]))/(FemurLength * Mass);
            dxdt(index+1,1)=dxdt(index,1)+ddxddt(index,1)*dt;
            x(index+1,1)=x(index,1)+dxdt(index,1)*dt;
        else
            temp=LegAngle(x(index,1),FemurLength);
            FlexorForce(index,1) = 0;
            FlexorTorque(index,1) = 0;
            springTorque(index,1) = SpringTorque(temp,[ExtensorMomentArm,ExtensorOffset,StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset]);
            springMomentArm(index,1) = SpringMomentArm(temp,[ExtensorMomentArm,ExtensorOffset]);
            springForce(index,1) = SpringForce(temp,[StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset]);
            ddxddt(index,1)=(SpringTorque(temp,[ExtensorMomentArm,ExtensorOffset,StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset])-0)/(FemurLength * Mass);
            dxdt(index+1,1)=dxdt(index,1)+ddxddt(index,1)*dt;
            x(index+1,1)=x(index,1)+dxdt(index,1)*dt;
        end
    else
        temp=LegAngle(x(index,1),FemurLength);
        FlexorForce(index,1) = StartFlexorForce;
        FlexorTorque(index,1) = MuscleTorque(LegAngle(x(index,1),FemurLength),[StartFlexorForce,FlexorMomentArm,FlexorOffset]);
        springTorque(index,1) = SpringTorque(temp,[ExtensorMomentArm,ExtensorOffset,StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset]);
        springMomentArm(index,1) = SpringMomentArm(temp,[ExtensorMomentArm,ExtensorOffset]);
        springForce(index,1) = SpringForce(temp,[StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset]);
        ddxddt(index,1)=(SpringTorque(temp,[ExtensorMomentArm,ExtensorOffset,StartStiffness,StartSpringLength,ExtensorMomentArm,InitialFlexionAngle,ExtensorOffset])-MuscleTorque(LegAngle(x(index,1),FemurLength),[StartFlexorForce,FlexorMomentArm,FlexorOffset]))...
            /(FemurLength * Mass);
        dxdt(index+1,1)=dxdt(index,1)+ddxddt(index,1)*dt;
        x(index+1,1)=x(index,1)+dxdt(index,1)*dt ;
    end
    time(index+1,1)=time(index,1)+dt;
   
end

% find unlatching, unlatched and take off indices
indices1 = find(time >= unlatchingTime);
unlatchingIndex = indices1(1);

indices2 = find (time >= unlatchingTime + t_delta);
unlatchedIndex = indices2(1);

indices3 = find(LegAngle(x,FemurLength) >= 180);
takeoffIndex = indices3(1);

% what happens if flexor still hasn't decayed to zero
% by the time take-off occurs?
if unlatchedIndex > takeoffIndex 
    tracker = 1;
else
    tracker = 0;
end

negativeIndices = find(round(ddxddt(:),5) < 0); % when does accleration become negative?
if ~isempty(negativeIndices)
    if (round(ddxddt(negativeIndices(1)),6) < 0)
        tracker2 = 1;
    else
        tracker2 = 0;
    end
else
    tracker2 = 0;
end

% compute output vector
outputParams.Data = [time(1:end-1),LegAngle(x(1:end-1),FemurLength),x(1:end-1),dxdt(1:end-1),ddxddt];
outputParams.unlatchingIndex = unlatchingIndex;
outputParams.takeoffIndex = takeoffIndex;
outputParams.unlatchedIndex = unlatchedIndex;
outputParams.tracker =  tracker;
outputParams.tracker2 = tracker2;
outputMisc = [FlexorForce,FlexorTorque,springTorque,springMomentArm,springForce];

% a = 1;

end
