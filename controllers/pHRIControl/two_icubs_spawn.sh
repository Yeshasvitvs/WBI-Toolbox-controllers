#! /bin/bash

gz model -m iCub -f /home/yeshi/SOFTWARE/icub-gazebo/icub/icub.sdf --pose-z 1 --pose-Y 3.14

sleep 2

gz model -m iCub_0 -f /home/yeshi/SOFTWARE/icub-gazebo/icub/icub.sdf --pose-x 0.8 --pose-z 1 

