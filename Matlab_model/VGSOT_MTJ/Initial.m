function[R_MTJ,theta,mz,phi]=Initial(PAP) 
%%初始化函数
%给定初始MTJ所处状态 PAP(1,反平行状态，0平行状态) phi（角动量在xoy面上的夹角）

%%
kb = 1.38e-23; 
T =300;
u0 = 12.56637e-7;            %Vacuum permeability in H/m
Ms = 0.625e6;                    %Saturation magnetization A/m 
Ki = 0.32e-3;                %The anisotropy energy in J/m2,
tf = 1.1e-9 ;                  %free layer thickness
D = 50e-9;                   % Diameter of MTJ
A1 = pi*(D^2)/4;             %MTJ Area
v = tf*A1 ;                  %the volumn of free layer 
Heff = (2*Ki)/(tf*Ms*u0);


if(PAP==1)
    theta = pi-sqrt((kb*T)/(u0*Ms*Heff*v));    %initial state is AP
    phi = pi;
    mz = cos(theta) ;
else 
    theta = sqrt((kb*T)/(u0*Ms*Heff*v));       %initial state is P
    phi = pi;
    mz = cos(theta) ;
end

%--------elementry constant-----%
m = 9.11e-31;                  %Electron Mass
e = 1.6e-19;                   %Elementary charge in C
h_bar = 1.054e-34;             %Reduced Planck constant in Js

%----MTJ参数----%
D = 50e-9;                     %Diameter of MTJ
tox =1.4e-9 ;                  %barrier thickness
A1 = pi*(D^2)/4;               %MTJ Area
%---Technology paraments --------%
phi_bar = 0.4;                 %Potential barrier height ,V
TMR = 1 ;

RA = 650e-12 ; 
F = (tox/(RA*phi_bar^(1/2)))*exp((2*tox*(2*m*e*phi_bar)^(1/2))/h_bar);     %fitting factor
Rp = (tox/(F*phi_bar^(1/2)*A1))*exp((2*tox*(2*m*e*phi_bar)^(1/2))/h_bar);  %Magenetoresistance at parallel state in Ohm, =100kOhm

R_MTJ = Rp*(1+TMR/(TMR+2))/(1+TMR*cos(theta)/(TMR+2)) ;
