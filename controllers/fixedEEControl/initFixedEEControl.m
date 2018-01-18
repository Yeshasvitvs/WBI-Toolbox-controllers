%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /**
%  * @author: Yeshasvi Tirupachuri
%  * Permission is granted to copy, distribute, and/or modify this program
%  * under the terms of the GNU General Public License, version 2 or any
%  * later version published by the Free Software Foundation.
%  *
%  * A copy of the license can be found at
%  * http://www.robotcub.org/icub/license/gpl.txt
%  *
%  * This program is distributed in the hope that it will be useful, but
%  * WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
%  * Public License for more details
%  */
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;

% End Effector link name
CONFIG.EE                               = 'r_hand';

% This sections contains information on the robot parts considered
%
% SM.SM_TYPE: defined the parts of the robot considered
%
% 'single_arm': the end effector defined by 'CONFIG.EE_link_name' will be
%               moved along a desired trajectory using the joints in a single arm
% 'upper_body': the end effector defined by 'CONFIG.EE_link_name' will be
%               moved along a desired trajectory using the joints in both the arms and
%               the torso of the robot
%               moved along a desired trajectory using 

%CONFIG.PARTS                            = 'single_arm';
CONFIG.PARTS                            = 'upper_body';

%% Configuration Object
WBTConfigRobot                          = WBToolbox.Configuration;

%% RobotConfiguration Data
WBTConfigRobot.RobotName                = 'icubSim';
WBTConfigRobot.UrdfFile                 = 'model.urdf';

if(strcmp(CONFIG.PARTS,'single_arm') && strcmp(CONFIG.EE,'r_hand'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'r_shoulder_pitch','r_shoulder_roll',...
                                           'r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'right_arm'};

elseif (strcmp(CONFIG.PARTS,'single_arm') && strcmp(CONFIG.EE,'l_hand'))
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'l_shoulder_pitch','l_shoulder_roll',...
                                           'l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'left_arm'};
    
else
    
    WBTConfigRobot.ControlledJoints     = {...
                                           'torso_pitch','torso_roll','torso_yaw',...
                                           'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                           'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    WBTConfigRobot.ControlBoardsNames   = {'torso','left_arm','right_arm'};

end

WBTConfigRobot.LocalName                = 'WBT';

%% Checking Configuration Success
if ~WBTConfigRobot.ValidConfiguration
    return
end

%%Runtime Position Error Visualization
CONFIG.PLOT.POS_ERR                      = false;

%% GENERAL SIMULATION INFOR
% If you are simulating the robot with Gazebo, 
% remember that you have to launch Gazebo as follow:
% 
% gazebo -slibgazebo_yarp_clock.so
% 
% and set the environmental variable YARP_ROBOT_NAME = icubGazeboSim.
% To do this, you can uncomment the

 setenv('YARP_ROBOT_NAME','icubGazeboSim');
% setenv('YARP_ROBOT_NAME','icubGenova04');


%% Simulation time in seconds
CONFIG.SIMULATION_TIME                  = inf;

%% PRELIMINARY CONFIGURATIONS
% This sections contains information on the state machines
%
% SM.SM_TYPE: defined the type of the state machine
%
% 'simpleEE': the robot will move its end effector along a desired
%             trajectory

SM.SM_TYPE                              = 'simpleEE';

% CONFIG.SCOPES: if set to true, all visualizers for debugging are active
CONFIG.SCOPES.ALL                       = true;

% You can also activate only some specific scopes for debugging
CONFIG.SCOPES.BASE_EST_IMU               = false;
CONFIG.SCOPES.EXTWRENCHES               = false;
CONFIG.SCOPES.GAIN_SCHE_INFO            = false;
CONFIG.SCOPES.MAIN                      = false;
CONFIG.SCOPES.QP                        = false;

% CONFIG.CHECK_LIMITS: if set to true, the controller will stop as soon as
%                      any of the joint limits are reached
CONFIG.CHECK_LIMITS                     = false;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURATIONS COMPLETED: loading gains and parameters for the specific robot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DO NOT MODIFY THE FOLLOWING VARIABLES, THEY ARE AUTOMATICALLY 
%% CHANGED WHEN SIMULATING THE ROBOT IN GAZEBO
WBT_modelName                           = 'matlabTorqueBalancing';
WBT_robotName                           = 'icub';
FRAMES.BASE                             = 'root_link';
FRAMES.IMU                              = 'imu_frame';

% CONFIG.USE_IMU4EST_BASE: if set to false, the base frame is estimated by 
% assuming that either the left or the right foot stay stuck on the ground. 
% Which foot the  controller uses depends on the contact forces acting on it. 
% If set to true, the base orientation is estimated by using the IMU, while
% the base position by assuming that the origin of either the right or the
% left foot do not move. 
CONFIG.USE_IMU4EST_BASE                 = false;

% CONFIG.YAW_IMU_FILTER and CONFIG.PITCH_IMU_FILTER: when the flag
% CONFIG.USE_IMU4EST_BASE = true, then the orientation of the floating base is
% estimated as explained above. However, the foot is usually perpendicular
% to gravity when the robot stands on flat surfaces, and rotation about the
% gravity axis may be due to the IMU drift in estimating this angle. Hence,
% when either of the flags CONFIG.YAW_IMU_FILTER or CONFIG.PITCH_IMU_FILTER
% is set to true, the yaw and/or pitch angles of the contact foot are
% ignored and kept equal to the initial values.
CONFIG.YAW_IMU_FILTER                   = true;
CONFIG.PITCH_IMU_FILTER                 = true;

% CONFIG.CORRECT_NECK_IMU: when set equal to true, the kineamtics from the
% IMU and the contact foot is corrected by using the neck angles. If it set
% equal to false, recall that the neck is assumed to be in (0,0,0)
CONFIG.CORRECT_NECK_IMU                 = true;

% CONFIG.ONSOFTCARPET: the third year CoDyCo review meeting consisted also
% of a validation scenarion in which the robot had to balance on a soft
% carpet. Hence, when CONFIG.ONSOFTCARPET = true, other sets of gains are
% loaded for the postural and CoM.
CONFIG.ONSOFTCARPET                     = false;

% CONFIG.USE_QP_SOLVER: if set to true, a QP solver is used to account for 
% inequality constraints of contact wrenches
CONFIG.USE_QP_SOLVER                    = true; 

PORTS.IMU                               = '/icub/inertial';
PORTS.COM_DES                           = ['/' WBT_modelName '/comDes:i'];
PORTS.EE_DES                            = ['/' WBT_modelName '/eeDes:i'];
PORTS.Q_DES                             = ['/' WBT_modelName '/qDes:i'];
PORTS.WBD_LEFTLEG_EE                    = '/wholeBodyDynamics/left_leg/cartesianEndEffectorWrench:o';
PORTS.WBD_RIGHTLEG_EE                   = '/wholeBodyDynamics/right_leg/cartesianEndEffectorWrench:o';
PORTS.WBD_LEFTHAND_EE                   = '/wholeBodyDynamics/left_hand/cartesianEndEffectorWrench:o';
PORTS.WBD_RIGHTHAND_EE                  = '/wholeBodyDynamics/right_hand/cartesianEndEffectorWrench:o';

% CONFIG.Ts: defines the controller period in secs
CONFIG.Ts                               = 0.01;

CONFIG.ON_GAZEBO                        = false; %%??
baseToWorldRotationPort                 = ['/' WBT_modelName '/floatingBaseRotationMatrix:i'];

run(strcat('app/robots/',getenv('YARP_ROBOT_NAME'),'/gains.m'));


