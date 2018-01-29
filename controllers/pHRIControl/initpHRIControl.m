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
clear; 
clc;

%% Robot Configuration

% End Effector link name
ROBOT.CONFIG.EE                               = 'r_hand';

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
ROBOT.CONFIG.PARTS                            = 'upper_body';

%% Configuration Object
ROBOT.WBTConfigRobot                          = WBToolbox.Configuration;

%% RobotConfiguration Data
ROBOT.WBTConfigRobot.RobotName                = 'icubSim';
ROBOT.WBTConfigRobot.UrdfFile                 = 'model.urdf';

if(strcmp(ROBOT.CONFIG.PARTS,'single_arm') && strcmp(ROBOT.CONFIG.EE,'r_hand'))
    
    ROBOT.WBTConfigRobot.ControlledJoints     = {...
                                                'r_shoulder_pitch','r_shoulder_roll',...
                                                'r_shoulder_yaw','r_elbow',...
                                                };
                                            
    ROBOT.WBTConfigRobot.ControlBoardsNames   = {'right_arm'};

elseif (strcmp(ROBOT.CONFIG.PARTS,'single_arm') && strcmp(ROBOT.CONFIG.EE,'l_hand'))
    
    ROBOT.WBTConfigRobot.ControlledJoints     = {...
                                                'l_shoulder_pitch','l_shoulder_roll',...
                                                'l_shoulder_yaw','l_elbow',...
                                                };
                                            
    ROBOT.WBTConfigRobot.ControlBoardsNames   = {'left_arm'};
    
else
    
    ROBOT.WBTConfigRobot.ControlledJoints     = {...
                                                'torso_pitch','torso_roll','torso_yaw',...
                                                'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow',...
                                                'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow',...
                                                };
                                            
    ROBOT.WBTConfigRobot.ControlBoardsNames   = {'torso','right_arm','left_arm'};

end

ROBOT.WBTConfigRobot.LocalName                = 'ROBOT_WBT';

%% Checking Configuration Success
if ~ROBOT.WBTConfigRobot.ValidConfiguration
    return
end

%% GENERAL SIMULATION INFO
% If you are simulating the robot with Gazebo, 
% remember that you have to launch Gazebo as follow:
% 
% gazebo -slibgazebo_yarp_clock.so
% 
% and set the environmental variable YARP_ROBOT_NAME = icubGazeboSim.
% To do this, you can uncomment the

setenv('YARP_ROBOT_NAME','icubGazeboSim');

%% Load Gains
run(strcat('app/robots/',getenv('YARP_ROBOT_NAME'),'/gains.m'));

%% Human Configuration

% End Effector link name
HUMAN.CONFIG.EE                               = 'r_hand';

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
HUMAN.CONFIG.PARTS                            = 'upper_body';

%% Configuration Object
HUMAN.WBTConfigRobot                          = WBToolbox.Configuration;

%% RobotConfiguration Data
HUMAN.WBTConfigRobot.RobotName                = 'humanSim';
HUMAN.WBTConfigRobot.UrdfFile                 = 'model.urdf';

if(strcmp(HUMAN.CONFIG.PARTS,'single_arm') && strcmp(HUMAN.CONFIG.EE,'r_hand'))
    
    HUMAN.WBTConfigRobot.ControlledJoints     = {...
                                           'r_shoulder_pitch','r_shoulder_roll',...
                                           'r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                          };
    HUMAN.WBTConfigRobot.ControlBoardsNames   = {'right_arm'};

elseif (strcmp(HUMAN.CONFIG.PARTS,'single_arm') && strcmp(HUMAN.CONFIG.EE,'l_hand'))
    
    HUMAN.WBTConfigRobot.ControlledJoints     = {...
                                           'l_shoulder_pitch','l_shoulder_roll',...
                                           'l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    HUMAN.WBTConfigRobot.ControlBoardsNames   = {'left_arm'};
    
else
    
    HUMAN.WBTConfigRobot.ControlledJoints     = {...
                                           'torso_pitch','torso_roll','torso_yaw',...
                                           'r_shoulder_pitch','r_shoulder_roll','r_shoulder_yaw','r_elbow',...
                                           'r_wrist_prosup',...
                                           'l_shoulder_pitch','l_shoulder_roll','l_shoulder_yaw','l_elbow',...
                                           'l_wrist_prosup',...
                                          };
    HUMAN.WBTConfigRobot.ControlBoardsNames   = {'torso','left_arm','right_arm'};

end

HUMAN.WBTConfigRobot.LocalName                = 'HUMAN_WBT';

%% Checking Configuration Success
if ~HUMAN.WBTConfigRobot.ValidConfiguration
    return
end

%% GENERAL SIMULATION INFO
% If you are simulating the robot with Gazebo, 
% remember that you have to launch Gazebo as follow:
% 
% gazebo -slibgazebo_yarp_clock.so
% 
% and set the environmental variable YARP_ROBOT_NAME = icubGazeboSim.
% To do this, you can uncomment the

setenv('YARP_HUMAN_NAME','humanGazeboSim');

%% Load Gains
run(strcat('app/robots/',getenv('YARP_HUMAN_NAME'),'/gains.m'));

