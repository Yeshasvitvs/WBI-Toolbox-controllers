function [fNoQP,fHDot,NA,tauModel,SIGMA_fH,SIGMA_NA,HessianMatrixQP2Feet,gradientQP2Feet,...
          ConstraintsMatrixQP2Feet,bVectorConstraintsQp2Feet] = ...
              ...
              balancingControl_v1(M_r,M_s,h_r,h_s,J_r,J_f,J_s,J_rDot_nu,J_fDot_nu_s,J_sDot_nu_s,w_H_lSole,w_H_rSole,w_p_CoM_r,...
                                  J_CoM_r,nu,gain,desired_x_dx_ddx_CoM_r,H_r,intH_r,w_R_s,desired_x_CoM_s,s_p_CoM_s,H_s,seesaw,...
                                  s_omega,reg,ConstraintsMatrix,bVectorConstraints,ROBOT_DOF,qj,qjDes)

% Constants and common parameters
s_R_w    = transpose(w_R_s);
e3       = [0;0;1];
g        = -9.81;
s_g      = s_R_w * g * e3;
rho      = seesaw.rho;
delta    = seesaw.delta;
w_r      = (delta * w_R_s * e3) -rho * e3;
s_r      = s_R_w * w_r;
s_v_s    = skew(s_r) * s_omega;
qjDot    = nu(7:end);

% Dimension of the joint configuration space
nDof = size(ROBOT_DOF,1);

% Total mass matrix
M = [M_r  zeros(nDof+6,6)
     zeros(6,nDof+6)  M_s];

% Total Coriolis and gravity terms
h = [h_r; h_s];

% Total Jacobian
J = [J_r            -J_f;
     zeros(5,nDof+6) J_s];

% Total Jacobian derivative times total velocity
JDot_nu = [(J_rDot_nu-J_fDot_nu_s);
            J_sDot_nu_s];

% Total control torques selector
S = [zeros(6,nDof);
     eye(nDof,nDof);
     zeros(6,nDof)];

%% Linear and angular momentum of the robot

w_p_lSole = w_H_lSole(1:3,4);
w_p_rSole = w_H_rSole(1:3,4);

w_gl  = w_p_lSole - w_p_CoM_r;
w_gr  = w_p_rSole - w_p_CoM_r;

% Matrix which projects forces into the robot momentum dynamics
AR = [eye(3)      zeros(3)  eye(3)      zeros(3)  zeros(3,5);
      skew(w_gl)  eye(3)    skew(w_gr)  eye(3)    zeros(3,5)];

% linear velocity of the robot CoM 
w_nu_CoM_r = J_CoM_r * nu;
w_v_CoM_r  = w_nu_CoM_r(1:3);
    
% gravity wrench in world frame   
gravityWrench_r = [(M_r(1,1)*g*e3);zeros(3,1)];

% saturate the robot CoM position error
saturated_xCoM  = saturate(gain.PCOM * (desired_x_dx_ddx_CoM_r(:,1)-w_p_CoM_r),-gain.P_SATURATION,gain.P_SATURATION);
  
% desired robot CoM acceleration
ddxCoM_star_r   = desired_x_dx_ddx_CoM_r(:,3) + saturated_xCoM + gain.DCOM * (desired_x_dx_ddx_CoM_r(:,2)-w_v_CoM_r);

% robot desired linear and angular momentum
H_rDot_star    = [(M_r(1,1) * ddxCoM_star_r); 
                  (-gain.DAngularMomentum * H_r(4:end) -gain.PAngularMomentum * intH_r(4:end))];
  
%% Linear and angular momentum of the seesaw

% Matrix which projects forces into the seesaw momentum dynamics
AS = [-transpose(J_f) transpose(J_s)]; 

% gravity wrench in seesaw frame  
gravityWrench_s = [(M_s(1,1)*s_g);zeros(3,1)];

% seesaw CoM velocity
s_v_CoM_s  = s_v_s;

% desired seesaw CoM acceleration
ddxCoM_star_s   = gain.PCOM_SEESAW * (desired_x_CoM_s - s_p_CoM_s) + gain.DCOM_SEESAW * (-s_v_CoM_s);

% robot desired linear and angular momentum
H_sDot_star    = [(M_s(1,1) * ddxCoM_star_s); 
                  (-gain.DAngularMomentum_seesaw * H_s(4:end))];

%% Desired forces 

% global forces multiplier and its nullspace
A     = [AR; AS];  
pinvA = pinv(A,reg.pinvTol);
NA    = eye(size(pinvA*A)) - pinvA*A;

HDot_star = [(H_rDot_star - gravityWrench_r);
             (H_sDot_star - gravityWrench_s)];

% forces and moments satisfying the momentum dynamics
fHDot = pinvA * HDot_star;

%% Control torques computation

% define the required parameters
JinvM       = J/M;
JinvMS      = JinvM * S;
JinvMJt     = JinvM * transpose(J);
pinv_JinvMS = pinvDamped(JinvMS,reg.pinvDamp); 
NullJinvMS  = eye(nDof) - pinv_JinvMS*JinvMS;

% multiplier of f in tau_0
JBar        = [(transpose(J_r(:,7:end))-M_r(7:end,1:6)/M_r(1:6,1:6)*transpose(J_r(:,1:6))) zeros(nDof,5)];
   
tauModel    = pinv_JinvMS*(JinvM*h - JDot_nu) + NullJinvMS*(h_r(7:end) -M_r(7:end,1:6)/M_r(1:6,1:6)*h_r(1:6) ...
             -gain.impedances*(qj-qjDes) -gain.dampings*qjDot);
  
SIGMA       = -(pinv_JinvMS*JinvMJt + NullJinvMS*JBar);
 
%% Optimization using quadratic programming (QP) solver

% parameters from control and dynamics
SIGMA_NA  = SIGMA * NA; 
SIGMA_fH  = SIGMA * fHDot;
w_R_lSole = w_H_lSole(1:3,1:3);
w_R_rSole = w_H_rSole(1:3,1:3);

% QP parameters
constraintMatrixLeftFoot  = ConstraintsMatrix * blkdiag(transpose(w_R_lSole),transpose(w_R_lSole));
constraintMatrixRightFoot = ConstraintsMatrix * blkdiag(transpose(w_R_rSole),transpose(w_R_rSole));
ConstraintsMatrix2Feet    = [blkdiag(constraintMatrixLeftFoot,constraintMatrixRightFoot) zeros(38,5)];
bVectorConstraints2Feet   = [bVectorConstraints;bVectorConstraints];

ConstraintsMatrixQP2Feet  = ConstraintsMatrix2Feet*NA;
bVectorConstraintsQp2Feet = bVectorConstraints2Feet-ConstraintsMatrix2Feet*fHDot;
HessianMatrixQP2Feet      = transpose(SIGMA_NA)*SIGMA_NA + eye(size(SIGMA_NA,2))*reg.HessianQP;
gradientQP2Feet           = transpose(SIGMA_NA)*(tauModel + SIGMA*fHDot);

fNoQP                     = -pinvDamped(SIGMA_NA,reg.pinvDamp*1e-5)*(tauModel + SIGMA*fHDot);

end