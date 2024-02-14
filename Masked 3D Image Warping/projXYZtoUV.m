function [u, v] = projXYZtoUV(m_Height, projMatrix, x, y, z)
%  PROJXYZTOUV  Return the image point (u, v) which is corresponding to 
%  an scene point (x, y) with respect to the world coordinate system
%  m_Height: the height of the image
%  projMatrix: projection matrix, 4x4
%  u, v: the coordinates of an image point (u, v)
%  x, y, z: the coordinates of the scene point(with respect to the world
%  coordinate system or named the global coordinate system)
% 
%  Ran Liu: liuran781101@tom.com
%  College of Computer Science, Chongqing University
%  Panovasic Technology Co.,Ltd

%%  �����������������ϵ�е�һ��(x,y,z,1)ӳ�䵽����ͼ������ϵ�е�һ��(u,v,1)������
%%  ���ֵz����z���ꡣ
tmp = projMatrix * [x; y; z; 1];
us = tmp(1:3, :);  %  3*1
us = hnormalise(us); %  ��Ϊ�淶���������

%  convert the computed (u,v) to the traditional coordinates where image (0,0) is top left corner
Trl = [1 0  0   
       0 -1 m_Height - 1  
       0 0  1];  % ��������ֻ�Ǵ���ļ��㣬���ÿ��ǻ���Ϊ0����Ϊ1������
us = Trl \ us;
% u = round(us(1)); % ȡ��
% v = round(us(2));
u = us(1);
v = us(2);