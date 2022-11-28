%%主函数main

close all;                     %close all figures
clc;
clear all;
%--------input parameter--------%
%----voltage value of T1、T2、T3 during sim_startup:sim_mid1--------% 
V1_1 = 1;
V2_1 = 0;
V3_1 = 0.1;
%----voltage value of T1、T2、T3 during sim_mid1+1:sim_mid2--------%
V1_2 = -1;
V2_2 = 0;
V3_2 = 0;
%----voltage value of T1、T2、T3 during sim_mid2+1:sim_end--------%
V1_3 = 0;
V2_3 = 0;
V3_3 = 0;
%--------set space of time------%
sim_startup = 1;                   %Voltage start, SOT start,STT start  
sim_mid1 = 2000;                    %Voltage start, SOT stop,STT continue
sim_mid2 = 2000;                    %Voltage stop, SOT stop,STT stop
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
  
V1 = V1_1;
V2 = V2_1;
V3 = V3_1 ;

R_MTJ = Matrix_R(loop,1);
[I_SOT,V_MTJ]= ELE(V1,V2,V3,R_MTJ) ;

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
  
V1 = V1_2;
V2 = V2_2;
V3 = V3_2 ;
R_MTJ = Matrix_R(loop,1);
[I_SOT,V_MTJ]= ELE(V1,V2,V3,R_MTJ) ;

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
      
V1 = V1_3;
V2 = V2_3;
V3 = V3_3;
R_MTJ = Matrix_R(loop,1);
[I_SOT,V_MTJ]= ELE(V1,V2,V3,R_MTJ) ;

ESTT = 1;  %1表示有STT效应，0表示没有STT效应
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
 
 for i = 1:1:5001
t_sim1(i,:) = t_sim(:,i);
 end 
 
 
for i = 1:1:5001
 
 V_MTJ = 0; 
 mz = Matrix_mz(i,1);
 [R_MTJ] = RES(V_MTJ,mz);
 Matrix_R(i,1) = R_MTJ;
 
end 

figure(1)
plot(t_sim,Matrix_mz,'r','linewidth',1.5);
xlabel('time','Fontsize',20);
ylabel('mz','Fontsize',20);
grid on;

figure(2)
plot(t_sim,Matrix_R,'r','linewidth',1.5);
xlabel('time','Fontsize',20);
ylabel('R_M_T_J','Fontsize',20);
grid on;