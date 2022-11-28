function[I_SOT,V_MTJ]= ELE(V1,V2,V3,R_MTJ)
%%
%------------------函数说明-----------------------%
%该函数为电气模型
%输入是三端口器件的电压值，与MTJ相接的端电压为V1，重金属条或者反铁磁条得左端电压为V2，右端电压为V3；以及MTJ得电阻值R_MTJ    
%输出是I_SOT,V_MTJ

%%
%------------------所需参数-----------------------%
%-----反铁磁条参数-----%
l = 60e-9;                     %length in m
w = 50e-9;                     %Width in m
d = 3e-9;                      %thichness in m
rho = 278e-8;                  %Resistivity of beta-IrMn
R_W = rho*l/(w*d);             %Resistance of beta-IrMn

%%
%------------------函数主体-----------------------%
V_MTJ = R_MTJ*(4*V1-2*V2-2*V3)/(4*R_MTJ+R_W) ;
I_SOT = (V2-V3)/R_W ;

