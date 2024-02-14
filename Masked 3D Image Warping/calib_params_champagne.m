%  calibParams.m
%  m_ProjMatrix: projection matrix
%  ���ļ��Ĳ����ڵ��ú���Ϊȫ�ֱ���

%% ������������Щ������Щ�롰champagne���������
MinZ = 2031.588498; 
MaxZ = 7784.110870;
LastLine = [0 0 0 1];
%% for camera 37
%  ��champagne�����������37���ڲ���������3x3 intrinsic matrix
m37_K = [2241.25607  0.0        701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  ����任����
m37_RT = [1.0 0.0 0.0 370.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  ���������37��4x4ͶӰ����m37_ProjMatrix
m37_ProjMatrix = m37_K * m37_RT; %  3x4ͶӰ����
m37_ProjMatrix = [m37_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 39
%  ��champagne�����������39���ڲ���������3x3 intrinsic matrix
m39_K = [2241.25607  0.0        701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  ����任����
m39_RT = [1.0 0.0 0.0 390.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  ���������39��4x4ͶӰ����m39_ProjMatrix
m39_ProjMatrix = m39_K * m39_RT; %  3x4ͶӰ����
m39_ProjMatrix = [m39_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 41
%  ��champagne�����������41���ڲ���������3x3 intrinsic matrix
m41_K = [2241.25607  0.0        701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  ����任����
m41_RT = [1.0 0.0 0.0 410.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  ���������41��4x4ͶӰ����m41_ProjMatrix
m41_ProjMatrix = m41_K * m41_RT; %  3x4ͶӰ����
m41_ProjMatrix = [m41_ProjMatrix; LastLine];  %  4x4ͶӰ����
