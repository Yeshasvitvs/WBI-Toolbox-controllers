
if(strcmp(ROBOT.CONFIG.PARTS,'single_arm'))
    ROBOT.ROBOT_DOF                                   = 4;
else
    ROBOT.ROBOT_DOF                                   = 11;
end

ROBOT.ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT.ROBOT_DOF);

%% Position Control Gains
ROBOT.GAINS.POSITION.Kp			    = diag([1000,1000,1000]);
ROBOT.GAINS.POSITION.Kd			    = 2*sqrt(ROBOT.GAINS.POSITION.Kp);
ROBOT.GAINS.POSITION.Eps			= 1e-20;

%% Postural Task Gains
ROBOT.GAINS.POSTURAL.Kp			    = diag([100,100,100,30,30,30,30,100,100,100,100]);
ROBOT.GAINS.POSTURAL.Kd			    = 2;


