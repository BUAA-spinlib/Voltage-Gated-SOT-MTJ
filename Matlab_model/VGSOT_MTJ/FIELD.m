function[H_EFF_x,H_EFF_y,H_EFF_z]= FIELD(theta,phi,V_MTJ,n,NON,ENE,VNV) 
%theta phi V_MTJ计算公式中的必要参数
%VNV：控制是否在模型中加入VCMA效应
%NON：控制是否加入热扰动效应 n：热扰动随机数的方差
%ENE：控制是否加入交换偏置场
%与various field的区别 Ms alpha tf的数值不同
%---------------needed parameters-----------------%
Ki = 0.32e-3;               %The anisotropy energy in J/m2,
u0 = 12.56637e-7;           %Vacuum permeability in H/m
Ms = 0.625e6;               %Saturation magnetization A/m
beta = 60e-15;              %VCMA coefficient in J/vm, =75fJ/vm 
tf = 1.1e-9 ;               %free layer thickness
tox =1.4e-9 ;               %barrier thickness
D = 50e-9;                  % Diameter of MTJ
A1 = pi*(D^2)/4;            %MTJ Area
v = tf*A1 ;                 %the volumn of free layer 
kb = 1.38e-23; 
T = 300;                    %Temperature in K
alpha = 0.05;               %Gilbert Damping Coefficent 
uB = 9.274e-24;             %Bohr magneton in J/T
t_step = 1e-12;
h_bar = 1.054e-34;          %Reduced Planck constant in Js
gamma = 2*u0*uB/h_bar; 
 
%-----Various kinds of fields----------------------%
  %-------------Perpendicular Magnetic Anisoropy Field-------------%
  H_PMA = (2*Ki/(u0*Ms*tf))*cos(theta);   
  %-------------Volatge-Controlled Magnetic Anisotropy Field-------------%
  H_VCMA = -(2*beta*V_MTJ/(u0*Ms*tox*tf))*cos(theta); 
  %-------------Demagnetization Field------------------------------%
  %Formula: Nz - Nx = 1 - 3*pi*tf/(4*a),            Ny = Nx
     Nx = pi*tf/(4*D);
     Ny = Nx;
     Nz = 1 - 2*Nx;
     N = [Nx 0 0;0 Ny 0;0 0 Nz];
     M = [sin(theta)*cos(phi),sin(theta)*sin(phi),cos(theta)];  
%      Nx = 0;
%      Ny = 0;
%      Nz = 1;
%      N = [Nx 0 0;0 Ny 0;0 0 Nz];
%      M = [sin(theta)*cos(phi),sin(theta)*sin(phi),cos(theta)];  
   
  
  H_D = -Ms*(M*N);
  %------------Exchange Bias Field-----------------------------%
  Hx = 0;        
  Hy = -50*79.5775; %-((2*Ki/(u0*Ms*tf))-Ms);   %-0*79.5775;              %An assisted field in y axis will speed up the switching, 100Oe
  Hz = 0;                        %1 Oe=1000/4pi A/m=79.5775 A/m, 1A/m=4pi*0.001 Oe=0.0126Oe
  e_x = [1 0 0];                 %x方向上的单位向量
  e_y = [0 1 0];                 %y
  e_z = [0 0 1];
  
  H_EX = Hx*e_x+Hy*e_y+Hz*e_z;
  %-----------Thermal Noise Field-----------------------------%
  [sigma_x,sigma_y,sigma_z] = stochastic(n);
  sigma =[sigma_x,sigma_y,sigma_z];                  %Gussian random varibles with a mean of 0 and a standard deviation of 1
  H_TH = sqrt(2*kb*T*alpha/(u0*Ms*gamma*v*t_step));  %只是为了方便后面相乘，因此没有乘上随机数
  %-----------The effective magnetic field-----------------------------%
  H_EFF_P = H_PMA + H_VCMA*VNV + H_D(:,3);
  H_EFF_x = Hx + H_D(:,1) + NON*sigma_x*H_TH;
  H_EFF_y = Hy*ENE + H_D(:,2) + NON*sigma_y*H_TH;
  H_EFF_z = Hz + H_EFF_P + NON*sigma_z*H_TH;
  %H_EFF = H_EFF_x*e_x + H_EFF_y*e_y + H_EFF_z*e_z;