%  calibParams.m
%  m_ProjMatrix: projection matrix
%  ���ļ��Ĳ����ڵ��ú���Ϊȫ�ֱ���

%% ������������Щ������Щ�롰balloons���������
MinZ = 448.251214; 
MaxZ = 11206.280350;
LastLine = [0 0 0 1];
%% for camera 1
%  ��balloons�����������1���ڲ���������3x3 intrinsic matrix
m1_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  ����任����
m1_RT = [1.0 0.0 0.0 5.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  ���������1��4x4ͶӰ����m1_ProjMatrix
m1_ProjMatrix = m1_K * m1_RT; %  3x4ͶӰ����
m1_ProjMatrix = [m1_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 2
%  ��balloons�����������2���ڲ���������3x3 intrinsic matrix
m2_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  ����任����
m2_RT = [1.0 0.0 0.0 10.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  ���������2��4x4ͶӰ����m2_ProjMatrix
m2_ProjMatrix = m2_K * m2_RT; %  3x4ͶӰ����
m2_ProjMatrix = [m2_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 3
%  ��balloons�����������3���ڲ���������3x3 intrinsic matrix
m3_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0];
%  ����任����
m3_RT = [1.0 0.0 0.0 15.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0];
%  ���������3��4x4ͶӰ����m3_ProjMatrix
m3_ProjMatrix = m3_K * m3_RT; %  3x4ͶӰ����
m3_ProjMatrix = [m3_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 4
%  ��balloons�����������4���ڲ���������3x3 intrinsic matrix
m4_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0 ];
%  ����任����
m4_RT = [1.0 0.0 0.0 20.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0 ];
%  ���������4��4x4ͶӰ����m4_ProjMatrix
m4_ProjMatrix = m4_K * m4_RT; %  3x4ͶӰ����
m4_ProjMatrix = [m4_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 5
%  ��balloons�����������5���ڲ���������3x3 intrinsic matrix
m5_K = [2241.25607  0.0         701.5
        0.0         2241.25607  514.5
        0.0         0.0         1.0 ];
%  ����任����
m5_RT = [1.0 0.0 0.0 25.0
         0.0 1.0 0.0 0.0 
         0.0 0.0 1.0 0.0 ];
%  ���������5��4x4ͶӰ����m5_ProjMatrix
m5_ProjMatrix = m5_K * m5_RT; %  3x4ͶӰ����
m5_ProjMatrix = [m5_ProjMatrix; LastLine];  %  4x4ͶӰ����