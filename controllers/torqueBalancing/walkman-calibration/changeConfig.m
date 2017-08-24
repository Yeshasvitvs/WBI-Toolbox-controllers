% changeConfig
%
% A simple function for switching between different joint configurations.
% All joint configurations are stored in this function. The joint position
% is switched every time an event is triggered
%
function qj = changeConfig(t,tswitch,qj0)

% matrix of custom joint positions [deg]
customValues   = [ 0  0   0     0  20  0  0  0     0 -20   0  0  0     0  20   0 0   0   0      0  -20   0  0   0   0;   % q1
                   0  0   0     20 20  0  0  0    20 -20   0  0  0     20 20   0 0   20  0      20 -20   0  0   20  0;   % q2
                   0  0   0    -20 20  0  0  0   -20 -20   0  0  0    -20 20   0 0  -20  0      20 -20   0  0  -20  0;   % q3
                  10  0   0    -20 20  10 0  0   -20 -20  10  0  0    -20 20  10 0  -20  20    -20 -20  10  0  -20  20;  % q4
                 -10  0   0    -20 20 -10 0  0   -20 -20 -10  0  0    -20 20 -10 0  -20 -20    -20 -20 -10  0  -20 -20;  % q5
                   0  10  0     0  30  0  10 0    0  -30   0  10 0     0  30  0 -20  0   0      0  -30  0  -20  0   0;   % q6
                   0 -10  0     0  30  0 -10 0    0  -30   0 -10 0     0  30  0 -20  0   0      0  -30  0  -20  0   0;   % q7
                   0  0   20    0  20  0  0  10   0  -20   0  0  10    0  20  0  0   0   0      0  -20  0   0   0   0;   % q8
                   0  0  -20    0  20  0  0 -10   0  -20   0  0 -10    0  20  0  0   0   0      0  -20  0   0   0   0;]; % q9

% add the initial joint configuration [rad]
jointPositions = [qj0 transpose(customValues)*pi/180 qj0];

% if t < tswitch(1), stay at the first configuration
qj = jointPositions(:,1);

for k = 1:length(tswitch)
    
    % if t >= tswitch(k), take the k-th configuration. Example:
    % 
    % jointPositions = [q0 q1 q2];
    % tswitch        = [10 20];
    % 
    % this means: t < 10         ---> q0 is taken
    %             10 >= t < 20   ---> q1 is taken
    %             t >= 20        ---> q2 is taken
    %
    if t >= tswitch(k)
    
        qj = jointPositions(:,k+1);
    end
    
end

end
