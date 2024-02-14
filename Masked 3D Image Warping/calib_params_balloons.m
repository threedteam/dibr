%  calibParams.m
%  m_ProjMatrix: projection matrix
%  本文件的参数在调用后会成为全局变量

%% 公共参数，这些参数有些与“balloons”序列相关
MinZ = 448.251214; 
MaxZ = 11206.280350;
LastLine = [0 0 0 1];
%% for camera 1
%  “balloons”序列摄像机1的内部参数矩阵，3x3 intrinsic matrix
m1_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  仿射变换矩阵
m1_RT = [1.0 0.0 0.0 5.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  计算摄像机1的4x4投影矩阵m1_ProjMatrix
m1_ProjMatrix = m1_K * m1_RT; %  3x4投影矩阵
m1_ProjMatrix = [m1_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 2
%  “balloons”序列摄像机2的内部参数矩阵，3x3 intrinsic matrix
m2_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  仿射变换矩阵
m2_RT = [1.0 0.0 0.0 10.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  计算摄像机2的4x4投影矩阵m2_ProjMatrix
m2_ProjMatrix = m2_K * m2_RT; %  3x4投影矩阵
m2_ProjMatrix = [m2_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 3
%  “balloons”序列摄像机3的内部参数矩阵，3x3 intrinsic matrix
m3_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  仿射变换矩阵
m3_RT = [1.0 0.0 0.0 15.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  计算摄像机3的4x4投影矩阵m3_ProjMatrix
m3_ProjMatrix = m3_K * m3_RT; %  3x4投影矩阵
m3_ProjMatrix = [m3_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 4
%  “balloons”序列摄像机4的内部参数矩阵，3x3 intrinsic matrix
m4_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0 ];
%  仿射变换矩阵
m4_RT = [1.0 0.0 0.0 20.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0 ];
%  计算摄像机4的4x4投影矩阵m4_ProjMatrix
m4_ProjMatrix = m4_K * m4_RT; %  3x4投影矩阵
m4_ProjMatrix = [m4_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 5
%  “balloons”序列摄像机5的内部参数矩阵，3x3 intrinsic matrix
m5_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0 ];
%  仿射变换矩阵
m5_RT = [1.0 0.0 0.0 25.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0 ];
%  计算摄像机5的4x4投影矩阵m5_ProjMatrix
m5_ProjMatrix = m5_K * m5_RT; %  3x4投影矩阵
m5_ProjMatrix = [m5_ProjMatrix; LastLine];  %  4x4投影矩阵