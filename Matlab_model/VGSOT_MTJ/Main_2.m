%input:V_MTJ&I_SOT
%%主函数main

close all;                     %close all figures
clc;
clear all;
%--------input parameter--------%
%----voltage and current input during sim_startup:sim_mid1--------%
VMTJ_1 = 0;
ISOT_1 = -95e-6;
%----voltage and current input during sim_mid1+1:sim_mid2--------%
VMTJ_2 = 0;
ISOT_2 = 0;
%----voltage and current input during sim_mid2+1:sim_end--------%
VMTJ_3 = 0;
ISOT_3 = 0;

%--------set space of time------%
sim_startup = 1;                   %Voltage start, SOT start,STT start  
sim_mid1 = 2000;                   %Voltage start, SOT stop,STT continue
sim_mid2 = 5000;                   %Voltage stop, SOT stop,STT stop
sim_end  = 5000;                   %Stabilization stage, simulation end,STT stop
t_step = 1e-12;                    %Simulation step in s, =0.001ns
t_sim = 0:t_step:t_step*sim_end;   %0: 1ps: 5ns

%-----initial matrix---------%
Matrix_mz = zeros(sim_end+1,1);
Matrix_theta =zeros(sim_end+1,1) ;
Matrix_phi = zeros(sim_end+1,1);
Matrix_R = zeros(sim_end+1,1);
Matrix_V = zeros(sim_end+1,1);
%%
PAP = 1;  %初始状态是反平行态

[R_MTJ,theta,mz,phi]=Initial(PAP)  ;

Matrix_mz(1,1) = mz;
Matrix_theta(1,1) = theta;
Matrix_phi(1,1) = phi;
Matrix_R(1,1) = R_MTJ;

%%

for loop = sim_startup:sim_mid1                  %SOT+STT            
  
I_SOT = ISOT_1;
V_MTJ = VMTJ_1;
R_MTJ = Matrix_R(loop,1);

ESTT = 0;  %1表示有STT效应，0表示没有STT效应
ESOT = 1;  %1表示有SOT效应，0表示没有SOT效应

[mz,phi_1,theta_1]= Sw(V_MTJ,I_SOT,R_MTJ,theta,phi,ESTT,ESOT);
theta = theta_1;
phi = phi_1;

[R_MTJ]=RES(V_MTJ,mz);

Matrix_mz(loop+1,1) = mz;
Matrix_theta(loop+1,1) = theta_1;
Matrix_phi(loop+1,1) = phi_1;
Matrix_R(loop+1,1) = R_MTJ;
Matrix_V(loop) = V_MTJ;

end

 for loop = sim_mid1+1:sim_mid2 
  
I_SOT = ISOT_2;
V_MTJ = VMTJ_2;

R_MTJ = Matrix_R(loop,1);

ESTT = 0;  %1表示有STT效应，0表示没有STT效应
ESOT = 1;  %1表示有SOT效应，0表示没有SOT效应

[mz,phi_1,theta_1]= Sw(V_MTJ,I_SOT,R_MTJ,theta,phi,ESTT,ESOT);
theta = theta_1;
phi = phi_1;

[R_MTJ]=RES(V_MTJ,mz);

Matrix_mz(loop+1,1) = mz;
Matrix_theta(loop+1,1) = theta_1;
Matrix_phi(loop+1,1) = phi_1;
Matrix_R(loop+1,1) = R_MTJ;
Matrix_V(loop) = V_MTJ;

 end

 for loop = sim_mid2+1:sim_end 
      
I_SOT = ISOT_3;
V_MTJ = VMTJ_3;

R_MTJ = Matrix_R(loop,1);

ESTT = 0;  %1表示有STT效应，0表示没有STT效应
ESOT = 1;  %1表示有SOT效应，0表示没有SOT效应
[mz,phi_1,theta_1]= Sw(V_MTJ,I_SOT,R_MTJ,theta,phi,ESTT,ESOT);
theta = theta_1;
phi = phi_1;

[R_MTJ]=RES(V_MTJ,mz);

Matrix_mz(loop+1,1) = mz;
Matrix_theta(loop+1,1) = theta_1;
Matrix_phi(loop+1,1) = phi_1;
Matrix_R(loop+1,1) = R_MTJ;
Matrix_V(loop) = V_MTJ;

 end

for i = 1:1:3001
t_sim1(i,:) = t_sim(:,i);
end 
 
figure(1)
plot(t_sim,Matrix_mz,'r','linewidth',1.5);
xlabel('time','Fontsize',20);
ylabel('mz','Fontsize',20);
grid on;