function[R_MTJ]=RES(V_MTJ,mz)
%%
%---------------����˵��---------------%
%�ú���Ϊ������ģ�� ͨ��MZ����R_MTJ
%����Ϊһ��������V_MTJ�Լ�mz
%���ΪR_MTJ

%%
Vh = 0.5;                      %Bias voltage at which TMR is divided by 2 
TMR = 1 ;

PAP = 0 ;
[R_MTJ,~,~,~]=Initial(PAP);   %����PAP =0 �õ�MTJ��P̬�ĵ���
Rp = R_MTJ;

R_MTJ = Rp*(1+(V_MTJ/Vh)^2+TMR)/(1+(V_MTJ/Vh)^2+TMR*(0.5*(1+mz)));



