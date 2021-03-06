%% OVERWRITING SOME OF THE PARAMETERS CONTAINED IN gains.m WHEN USING FSM
if strcmpi(SM.SM_TYPE, 'WALKING')
    reg.pinvDamp    = 0.0001;
    sat.torque = 50;

    references.joints.smoothingTime    = 5;
    references.com.smoothingTime       = references.joints.smoothingTime;
    gain.SmoothingTimeImp              = references.joints.smoothingTime;  

    smoothingTimeTransitionDynamics    = 0.02;


    gain.PCOM              = diag([50    50  50]); 
    gain.ICOM              = diag([  0    0   0]);
    gain.DCOM              = 0*sqrt(gain.PCOM);

    gain.PAngularMomentum  = 1 ;

    %                   %   TORSO  %%         LEFT LEG            %%         RIGHT LEG           %% 
    gain.impedances  = [10   10   20, 30   30   20    20     10  10, 30   50   30    60      5   5    % state ==  1  WATING FOR REFERENCES
                        10   10   20, 30   30   20    20     10  10, 30   50   30    60      5   5    % state ==  2  TWO FEET BALANCING
                        10   10   20, 30   30   20    20     10  10, 30   50   30    60      5   5    % state ==  3  LEFT FOOT BALANCING
                        10   10   20, 30   50   30    60      5   5, 30   30   20    20     10  10];  % state ==  4  RIGHT FOOT BALANCING
                        

gain.dampings           = 0.0*sqrt(gain.impedances(4,:));

%% %%%%%%%%%%%%%%%%    FINITE STATE MACHINE SPECIFIC PARAMETERS
sm.com.threshold                =   0.02;
sm.wrench.threshold             = 120;
sm.joints.thresholdNotInContact =  3;
sm.joints.thresholdInContact    = 80;

sm.stateAt0               = 1;

sm.DT                     = 1;

end              
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      
         


sm.joints.smoothingTime    = references.joints.smoothingTime;
sm.com.smoothingTime       = references.com.smoothingTime;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      
         