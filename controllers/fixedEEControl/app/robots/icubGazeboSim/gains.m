
if(strcmp(CONFIG.PARTS,'single_arm'))
    ROBOT_DOF                                   = 4;
else
    ROBOT_DOF                                   = 11;
end

CONFIG.ON_GAZEBO                            = true;
PORTS.IMU                                   = '/icubSim/inertial';

%% Desired Trajectory Smoothing, if set to 1 the desired values are smoothed internally

CONFIG.SMOOTH_DES_COM                       = 0;
CONFIG.SMOOTH_DES_EE                        = 0;
CONFIG.SMOOTH_DES_Q                         = 0;

WBT_wbiList                                 = '(torso_pitch,torso_roll,torso_yaw,l_shoulder_pitch, l_shoulder_roll, l_shoulder_yaw, l_elbow, r_shoulder_pitch,r_shoulder_roll, r_shoulder_yaw, r_elbow)';
WBT_robotName                               = 'icubSim';

dump.left_hand_wrench_port                  = '/icubSim/left_hand/analog:o';
dump.right_hand_wrench_port                 = '/icubSim/right_hand/analog:o';

references.smoothingTimeMinJerkEEDesQDes    = 3.0;

sat.torque                                  = 34;

CONFIG.smoothingTimeTranDynamics            = 0.05;

ROBOT_DOF_FOR_SIMULINK                      = eye(ROBOT_DOF);
gain.qTildeMax                              = 20*pi/180;
postures                                    = 0;

gain.SmoothingTimeImp                       = 1;
gain.SmoothingTimeGainScheduling            = 0.02;

