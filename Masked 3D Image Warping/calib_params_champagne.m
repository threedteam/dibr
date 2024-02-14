%  calibParams.m
%  m_ProjMatrix: projection matrix
%  本文件的参数在调用后会成为全局变量

%% 公共参数，这些参数有些与“champagne”序列相关
MinZ = 2031.588498; 
MaxZ = 7784.110870;
LastLine = [0 0 0 1];
%% for camera 37
%  “champagne”序列摄像机37的内部参数矩阵，3x3 intrinsic matrix
m37_K = [2241.25607  0.0        701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  仿射变换矩阵
m37_RT = [1.0 0.0 0.0 370.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  计算摄像机37的4x4投影矩阵m37_ProjMatrix
m37_ProjMatrix = m37_K * m37_RT; %  3x4投影矩阵
m37_ProjMatrix = [m37_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 39
%  “champagne”序列摄像机39的内部参数矩阵，3x3 intrinsic matrix
m39_K = [2241.25607  0.0        701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  仿射变换矩阵
m39_RT = [1.0 0.0 0.0 390.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  计算摄像机39的4x4投影矩阵m39_ProjMatrix
m39_ProjMatrix = m39_K * m39_RT; %  3x4投影矩阵
m39_ProjMatrix = [m39_ProjMatrix; LastLine];  %  4x4投影矩阵

%% for camera 41
%  “champagne”序列摄像机41的内部参数矩阵，3x3 intrinsic matrix
m41_K = [2241.25607  0.0        701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  仿射变换矩阵
m41_RT = [1.0 0.0 0.0 410.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  计算摄像机41的4x4投影矩阵m41_ProjMatrix
m41_ProjMatrix = m41_K * m41_RT; %  3x4投影矩阵
m41_ProjMatrix = [m41_ProjMatrix; LastLine];  %  4x4投影矩阵
