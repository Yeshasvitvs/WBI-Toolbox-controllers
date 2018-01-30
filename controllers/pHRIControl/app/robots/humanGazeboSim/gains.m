
if(strcmp(HUMAN.CONFIG.PARTS,'single_arm'))
    HUMAN.ROBOT_DOF                                   = 4;
else
    HUMAN.ROBOT_DOF                                   = 11;
end

HUMAN.ROBOT_DOF_FOR_SIMULINK                      = eye(HUMAN.ROBOT_DOF);

%% Position Control Gains
HUMAN.GAINS.POSITION.Kp			    = diag([1000,1000,1000]);
HUMAN.GAINS.POSITION.Kd			    = 2*sqrt(HUMAN.GAINS.POSITION.Kp);
HUMAN.GAINS.POSITION.Eps			    = 1e-20;

%% Postural Task Gains
HUMAN.GAINS.POSTURAL.Kp			    = diag([100,100,100,30,30,30,30,100,100,100,100]);
HUMAN.GAINS.POSTURAL.Kd			    = 2;


