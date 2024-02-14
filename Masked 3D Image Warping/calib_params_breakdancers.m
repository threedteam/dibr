%  calibParams.m
%  m_ProjMatrix: projection matrix
%  ���ļ��Ĳ����ڵ��ú���Ϊȫ�ֱ���
%  ��Ȼ: liuran781101@tom.com

%% ������������Щ������Щ�롰Breakdancers���������
MinZ = 44.0; 
MaxZ = 120.0;
LastLine = [0 0 0 1];

%% for camera 4
%  ��Breakdancers�����������4���ڲ���������3x3 intrinsic matrix
m4_K = [1877.360000	0.415492    579.467000
        0.0         1882.430000 409.612000
        0.0         0.0         1.0];
%  ���������4��4x4ͶӰ����m4_ProjMatrix 
%  ����任����
m4_RT = [1.000000  0.000000  -0.000000 0.000006
         0.000000  1.000000  -0.000000 0.000001
         -0.000000 -0.000000 1.000000 -0.000003];
m4_ProjMatrix = m4_K * m4_RT; %  3x4ͶӰ����
m4_ProjMatrix = [m4_ProjMatrix; LastLine];  %  4x4ͶӰ����

%% for camera 5
%  ��Breakdancers�����������5���ڲ���������3x3 intrinsic matrix
m5_K = [1871.230000	0.747826	540.106000
        0.0	        1877.300000	412.656000
        0.0	        0.0	        1.0];
%  ���������5��4x4ͶӰ����m5_ProjMatrix 
%  ����任����
m5_RT = [0.998897	-0.017983	-0.043130	3.858103
         0.017587	0.999799	-0.009367	0.069365
         0.043289	0.008599	0.999013	0.606667];
m5_ProjMatrix = m5_K * m5_RT; %  3x4ͶӰ����
m5_ProjMatrix = [m5_ProjMatrix; LastLine];  %  4x4ͶӰ����