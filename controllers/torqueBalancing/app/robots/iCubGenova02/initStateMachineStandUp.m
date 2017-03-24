%% OVERWRITING SOME OF THE PARAMETERS CONTAINED IN gains.m WHEN USING FSM
if strcmpi(SM.SM_TYPE, 'STANDUP')
    
    CONFIG.SMOOTH_DES_COM      = 1;    % If equal to one, the desired streamed values 
                                       % of the center of mass are smoothed internally 
    CONFIG.SMOOTH_DES_Q        = 1;    % If equal to one, the desired streamed values 
                                       % of the postural tasks are smoothed internally    
  
     %% State parameters
     sm.stateAt0                   = 1;
     sm.tBalancing                 = 1;
     sm.jointsAndCoMSmoothingTimes = [1;    % state ==  1  BALANCING ON THE LEGS
                                      0.5;  % state ==  2  MOVE COM FORWARD
                                      0;    % state ==  3  TWO FEET BALANCING
                                      1];   % state ==  4  LIFTING UP  
     
     % smoothing time for time varying impedances
     gain.SmoothingTimeGainScheduling = 2;  
     
     reg.pinvTol     = 1e-5;
     reg.pinvDamp    = 1; 
     reg.pinvDampVb  = 1e-7;
     reg.HessianQP   = 1e-7;
     reg.impedances  = 0.1;
     reg.dampings    = 0;
     
     %% Contact constraints
     sat.torque                =  25;
     phys.legSize              =  [-0.025  0.025 ;        % xMin, xMax
                                   -0.025  0.025];        % yMin, yMax 
     gain.legSize              =  [-0.025  0.025 ;        % xMin, xMax
                                   -0.025  0.025];        % yMin, yMax 
                                       
     addpath('../../../../utilityMatlabFunctions/')
     [ConstraintsMatrixLegs,bVectorConstraintsLegs] = constraints...
     (forceFrictionCoefficient,numberOfPoints,torsionalFrictionCoefficient,gain.legSize,fZmin);

     gain.PCOM     =    [50   50  50;    % state ==  1  BALANCING ON THE LEGS
                         70   50  50;    % state ==  2  MOVE COM FORWARD
                         30   60  60;    % state ==  3  LOOKING FOR CONTACT
                         50   50  50];   % state ==  4  TWO FEET BALANCING

     gain.ICOM     = gain.PCOM*0;
     gain.DCOM     = 2*sqrt(gain.PCOM)*0;

     gain.PAngularMomentum  = 1 ;
     gain.DAngularMomentum  = 2*sqrt(gain.PAngularMomentum);

                         %   TORSO %%      LEFT ARM    %%      RIGHT ARM   %%         LEFT LEG           %%         RIGHT LEG          %% 
     gain.impedances  = [10   30   20, 10   10    10    8, 10   10    10    8, 30   50   30    60    50  50, 30   50   30    60    50  50;   % state ==  1  BALANCING ON THE LEGS
                         10   30   20, 10   10    10    8, 10   10    10    8, 30   50   30    60    50  50, 30   50   30    60    50  50;   % state ==  2  MOVE COM FORWARD
                         10   30   20, 10   10    10    8, 10   10    10    8, 30   50   30    60    50  50, 30   50   30    60    50  50;   % state ==  3  LOOKING FOR CONTACT
                         10   30   20, 10   10    10    8, 10   10    10    8, 30   50   30    60    50  50, 30   50   30    60    50  50];  % state ==  4  TWO FEET BALANCING

     gain.impedances(3,:) = gain.impedances(3,:)./2;      
                     
end

                                  %Hip pitch  %Hip roll  %Knee     %Ankle pitch  %Shoulder pitch  %Shoulder roll  %Shoulder yaw   %Elbow   %Torso pitch                        
sm.joints.standUpPositions     = [0.0000      0.0000     0.0000    0.0000        0.0000           0.0000          0.0000          0.0000   0.0000;   % state ==  1  THIS REFERENCE IS NOT USED
                                  1.5402      0.1594    -1.7365   -0.2814       -1.6455           0.1920          0.5862          0.2473   0.1928;   % state ==  2  MOVE COM FORWARD
                                  1.1097      0.0122    -0.8365   -0.0714       -1.4615           0.1920          0.1545          0.2018   0.0611;   % state ==  3  TWO FEET BALANCING
                                  0.2094      0.1047    -0.1745   -0.0349       -1.6455           0.1920          0.5862          0.2473   0.0000];  % state ==  4  LIFTING UP

sm.joints.leftAnkleCorrection  = -0.1745;

sm.CoM.standUpDeltaCoM         = [0.0     0.0   0.0;       % state ==  1  THIS REFERENCE IS NOT USED
                                 -0.0867  0.0   0.0;       % state ==  2  MOVE COM FORWARD
                                  0.0     0.0   0.0;       % state ==  3  TWO FEET BALANCING
                                  0.0     0.0   0.29];     % state ==  4  LIFTING UP
 
sm.LwrenchTreshold    = [0;   % state ==  1  THIS REFERENCE IS NOT USED
                         57;  % state ==  2  MOVE COM FORWARD
                         140  % state ==  3  TWO FEET BALANCING
                         0];  % state ==  4  THIS REFERENCE IS NOT USED
                     
sm.RwrenchTreshold    = [0    % state ==  1  THIS REFERENCE IS NOT USED
                         57;  % state ==  2  MOVE COM FORWARD
                         140  % state ==  3  TWO FEET BALANCING
                         0];  % state ==  4  THIS REFERENCE IS NOT USED
