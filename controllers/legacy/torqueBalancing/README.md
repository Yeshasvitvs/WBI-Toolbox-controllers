##Module description

This module implements a torque control balancing strategy.
It computes the interaction forces at the feet in order to stabilise a desired centroidal dynamics, which implies the tracking of a desired center-of-mass trajectory.
A cost function penalizing high joint torques - that generate the feet forces - is added to the control framework.

For details see [iCub whole-body control through force regulation on rigid non-coplanar contacts](http://journal.frontiersin.org/article/10.3389/frobt.2015.00006/abstract)

###Launch procedure
The procedure to run the torque balancing module is still quite elaborate.
Users willing to use the module should follow this list.

- Set the environmental variable YARP_ROBOT_NAME in the bashrc according to the robot one wants to use (e.g. icubGazeboSim for simulations, or iCubGenova01, iCubParis01, etc. for experiments).
- (Simulation only) Launch gazebo. If you want to use the synchronization between controller and simulator to avoid real-time factor related problems, launch gazebo as follows: `gazebo -slibgazebo_yarp_clock.so` In this case, set the environmental variable `YARP_CLOCK=/clock` in the bashrc.
- Bring the robot in a suitable home position (e.g. `$ yarpmotorgui --from homePoseBalancingTwoFeet.ini` and then pressing the 'Home All' button)
- (Robot Only) Launch `wholeBodyDynamicsTree` with the following parameters: `--autoconnect --assume_fixed l_foot_dh_frame`
- (Robot Only) Execute the [sensors calibration script](https://github.com/robotology/codyco-modules/blob/master/src/scripts/twoFeetStandingIdleAndCalib.sh): `$ twoFeetStandingIdleAndCalib.sh`
- Set the working directory of MATLAB to the directory containing the `torqueBalncing.mdl` model. 
- Open the simulink model `torqueBalancing.mdl`
- Run the module 

##Module details
###Configuration file
At start, the module calls the initialization file initTorqueBalancing.m. Once open, this file contains some configuration variables.
####General section
- `robotName : port prefix prepended to the ports of the robot to connect to, i.e. 'icubSim' for simulations, or 'icub' for experiments`
- `localName`: module name. Ports will be opened with this name. Default to `matlabTorqueBalancing`
- `simulationTime`: time of the simulation/experiment
- `USE_QP_SOLVER`: if 1, then a QP will be used to generate torques. If 0, classical pseudo-inverse are used
- `LEFT_RIGHT_FOOT_IN_CONTACT`: this two-element vector specifies which foot is in contact with the ground at the start fo the module. [1 1]: both feet in contact, [1 0] left foot in contact; [0 1] right foot in contact;  
- `DEMO_MOVEMENTS`: if equal to 1 and the robot is standing on double support, then it will perform the classical left-and-right.  

####Gains
The gains for the robot specified by the variable YARP_ROBOT_NAME can be found in the folder `robots/YARP_ROBOT_NAME/gains.m`. This file contains several gains, among which

- `maxTorque`: saturations to be applied to the output torques. It must be a positive value.
- `gain.PCOM`: proportional gains. 3 values
- `gain.DCOM`: derivative gains. 3 values
- `gain.ICOM`: integral gains. 3 values
- `gain.PAngularMomentum`: gain used for the desired rate of change of the momentum. One value
- `impTorso, impArms, impLeftLeg, impRightLeg`: gains for the impedance (low level) task. The number must match the number of torque controlled joints.

The latter five gains can be chosen differently for one foor, or two feet balancing.

#### CoM reference
It is possible to send a `CoM` reference by connecting to the streaming port `comDes:i`. The port expects 9 elements: 3 values for the  desired CoM  position, 3 values for the  desired CoM velocity and 3 values for the  desired CoM acceleration

#### Joint reference
It is possible to send the impedance resting position as a reference to the streaming port `qdes:i`. This port expects the same number of element as the torque controlled joints. References are in **radians**


#### Citing this contribution
In case you want to cite the content of this module please refer to [iCub whole-body control through force regulation on rigid non-coplanar contacts](http://journal.frontiersin.org/article/10.3389/frobt.2015.00006/abstract) and use the following bibtex entry:

```
 @article{Nori_etal2015,
 author="Nori, F. and Traversaro, S. and Eljaik, J. and Romano, F. and Del Prete, A. and Pucci, D.",
 title="iCub whole-body control through force regulation on rigid non-coplanar contacts",
 year="2015",
 journal="Frontiers in {R}obotics and {A}{I}",
 volume="1"
 }
```
