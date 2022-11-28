function[mz,phi_1,theta_1]= Sw(V_MTJ,I_SOT,R_MTJ,theta,phi,ESTT,ESOT)
%该函数为翻转模型，输入为V_MTJ I_SOT ESTT(1为由STT效应，0为没有) ESOT(1为由SOT效应，0为没有) 
%输出是mz

%----need parameter-------%
%--------elementry constant-----%
u0 = 12.56637e-7;              %Vacuum permeability in H/m
e = 1.6e-19;                   %Elementary charge in C
h_bar = 1.054e-34;             %Reduced Planck constant in Js
uB = 9.274e-24;                %Bohr magneton in J/T
gamma = 2*u0*uB/h_bar;         %Gyromagnetic ratio in m/As
tf = 1.1e-9 ;                  %free layer thickness
%---Technology paraments --------%
Ms = 0.625e6;                  %Saturation magnetization A/m
P = 0.58;                      %Spin polarization of the tunnel curdsdrent 0.6
theta_SH = 0.25;               %Spin Hall angle         
alpha = 0.05;
%------antiferromagnetic strip paraments--------------%
w = 50e-9;                     %Width in m
d = 3e-9;                      %thichness in m
A2 = d*w;                      %Cross-sectional area , in m2
t_step = 1e-12;                    %Simulation step in s, =0.001ns
%----MTJ参数----%
D = 50e-9;                     %Diameter of MTJ
A1 = pi*(D^2)/4;               %MTJ Area

R_STT_FL_DL = 0;  %0.25
R_SOT_FL_DL = 0;  %0.83
%%
I_MTJ = V_MTJ/R_MTJ;
J_STT = I_MTJ/A1;
J_SOT = I_SOT/A2;  

gammar = gamma/(1+alpha*alpha);  %Reduced gyromagnetic ratio
t_DSTT = ESTT*gamma*h_bar*P*J_STT/(2*e*u0*Ms*tf);
t_FSTT = R_STT_FL_DL*t_DSTT ;
t_DSOT = ESOT*gamma*h_bar*theta_SH*J_SOT/(2*e*u0*Ms*tf);
t_FSOT = R_SOT_FL_DL*t_DSOT;

%-----field函数所需要的参数-----%
n = 1;            
NON = 0;  %控制随机热效应的添加 1为有 0为无
ENE = 1;  %控制外场效应的添加 1为有 0为无
VNV = 1;  %控制VCMA效应的添加 1为有 0为无

[H_EFF_x,H_EFF_y,H_EFF_z]= field(theta,phi,V_MTJ,n,NON,ENE,VNV) ;
%----LLG------------------%
theta_1 = theta; 
phi_1 = phi ;

dtheta = gammar*(H_EFF_x*(alpha*cos(theta_1)*cos(phi_1)-sin(phi_1))+H_EFF_y*(alpha*cos(theta_1)*sin(phi_1)+cos(phi_1))-alpha*H_EFF_z*sin(theta_1))+(alpha*t_FSTT-t_DSTT)*sin(theta_1)/(1+alpha*alpha)-(alpha*sin(phi_1)+cos(theta_1)*cos(phi_1))*t_DSOT/(1+alpha*alpha)+(alpha*cos(theta_1)*cos(phi_1)-sin(phi_1))*t_FSOT/(1+alpha*alpha);
dphi = gammar*(H_EFF_x*(-alpha*sin(phi_1)-cos(theta_1)*cos(phi_1))+H_EFF_y*(alpha*cos(phi_1)-cos(theta_1)*sin(phi_1))+H_EFF_z*sin(theta_1))/sin(theta_1)-(alpha*t_DSTT+t_FSTT)/(1+alpha*alpha)-(alpha*cos(theta_1)*cos(phi_1)-sin(phi_1))*t_DSOT/((1+alpha*alpha)*sin(theta_1))-(alpha*sin(phi_1)-cos(theta_1)*cos(phi_1))*t_FSOT/((1+alpha*alpha)*sin(theta_1));

phi_1 = phi_1 + t_step*dphi;                      %Adopt the rectangular integral 
theta_1 = theta_1 + t_step*dtheta;

mz = cos(theta_1);
