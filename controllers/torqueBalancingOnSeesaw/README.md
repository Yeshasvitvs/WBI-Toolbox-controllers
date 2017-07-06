# README 

This balancing controller aims to balance iCub robot while standing on a moving platform, i.e. the seesaw.

# Structure of the repository:

- simulink
- imuCalib

# simulink

Contains the simulink diagram and the initialization file for balancing controller.

## how to run a simulation:

- install [icub-gazebo-wholebody]() repository and follow the [seesaw README]().
- open the [simulink model]() and let it run!

# imuCalib 

A Simulink model for verifying seesaw IMU measurements. Connect the FOG IMU following the instructions 
in [kvh-yarp-devices]() and then run the model.
