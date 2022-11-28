function[R_MTJ]=RES(V_MTJ,mz)
%%
%---------------函数说明---------------%
%该函数为隧穿磁阻模型 通过MZ计算R_MTJ
%输入为一个给定的V_MTJ以及mz
%输出为R_MTJ

%%
Vh = 0.5;                      %Bias voltage at which TMR is divided by 2 
TMR = 1 ;

PAP = 0 ;
[R_MTJ,~,~,~]=Initial(PAP);   %输入PAP =0 得到MTJ的P态的电阻
Rp = R_MTJ;

R_MTJ = Rp*(1+(V_MTJ/Vh)^2+TMR)/(1+(V_MTJ/Vh)^2+TMR*(0.5*(1+mz)));



