%  calibParams.m
%  m_ProjMatrix: projection matrix
%  本文件的参数在调用后会成为全局变量
%  刘然: liuran781101@tom.com

%% 公共参数，这些参数有些与“Ballet”序列相关
MinZ = 42.0;
MaxZ = 130.0;
LastLine = [0 0 0 1];

%% for camera 4
%  “Ballet”序列摄像机4的内部参数矩阵，3x3 intrinsic matrix
m4_K = [1908.250000	0.335031	560.336000
        0.0         1914.160000	409.596000
        0.0         0.0         1.0];
%  计算摄像机4的4x4投影矩阵m4_ProjMatrix 
%  仿射变换矩阵
m4_RT = [1.000000	0.000000	0.000000	-0.000002
         0.000000	1.000000	-0.000000	0.000006
         0.000000	-0.000000	1.000000	0.000000];
m4_ProjMatrix = m4_K * m4_RT; %  3x4投影矩阵
m4_ProjMatrix = [m4_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 5
%  “Ballet”序列摄像机5的内部参数矩阵，3x3 intrinsic matrix
m5_K = [1915.780000	1.210910	527.609000;   
        0.0	        1921.730000	394.455000
        0.0	        0.0	        1.0];
%  计算摄像机5的4x4投影矩阵m5_ProjMatrix 
%  仿射变换矩阵
m5_RT = [0.998175	0.028914	-0.053000	3.849864
         -0.028594	0.999567	0.006786	0.041657
         0.053173	-0.005258	0.998570	0.428967];
m5_ProjMatrix = m5_K * m5_RT; %  3x4投影矩阵
m5_ProjMatrix = [m5_ProjMatrix; LastLine];  %  4x4投影矩阵