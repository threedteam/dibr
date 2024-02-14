function [x, y] = projUVZtoXY(m_Height, projMatrix, u, v, z)
%  PROJUVZTOXY  Return the scene point (X, Y) with respect to the world
%  coordinate system which is corresponding to an image point (u, v)
%  m_Height: the height of the image
%  projMatrix: projection matrix, 4x4
%  u, v: the coordinates of an image point (u, v)
%  x, y, z: the coordinates of the scene point(with respect to the world
%  coordinate system or named the global coordinate system)
% 
%  Ran Liu: liuran781101@tom.com
%  College of Computer Science, Chongqing University
%  Panovasic Technology Co.,Ltd

%%  �������������ͼ������ϵ�е�һ��(u,v,1)ӳ�䵽��������ϵ�е�һ��(x,y,z,1)������
%%  ���ֵz����z���ꡣ

%  ������ԭ������Ͻ��ƶ������½ǲ�ʹ��������ϵת��Ϊ��������ϵ�ı任����
%  �ڱ궨ʱ������ͼ������ϵ��ԭ��ٶ���ͼ������½ǣ������ּٶ���
%  ȷ����������ڲ��������󡣶����յõ���ͼ�������ͼ������ϵ�Դ�ͳ��
%  ��ʽ����ʾ����ԭ����ͼ������Ͻǡ��������Ҫ���������
%  �������������ϵ����������ϵ��
%  ��ƽ��һ��������Ϊ�����������еĻ���Ϊ1����һ��
Trl = [1 0  0   
       0 -1 m_Height - 1  
       0 0  1];  % ��������ֻ�Ǵ���ļ��㣬���ÿ��ǻ���Ϊ0����Ϊ1�����⡣
                 % ���Ҫ����ͼ��ʱ������Ҫ��ʾ�����ͼ��ʱ��Ӧ�ÿ���
   
newu = Trl * [u; v; 1];  
u = newu(1);
v = newu(2);

%  ��Щʽ�����ɽⷽ�̵õ���
c0 = z * projMatrix(1, 3) + projMatrix(1, 4);  
c1 = z * projMatrix(2, 3) + projMatrix(2, 4);
c2 = z * projMatrix(3, 3) + projMatrix(3, 4);

y = u * (c1 * projMatrix(3, 1) - projMatrix(2, 1) * c2) + ...
    v * (c2 * projMatrix(1, 1) - projMatrix(3, 1) * c0) + ...
    projMatrix(2, 1) * c0 - c1 * projMatrix(1, 1);

tmp = v * (projMatrix(3, 1) * projMatrix(1, 2) - projMatrix(3, 2) * projMatrix(1, 1)) + ...
		u * (projMatrix(2, 1) * projMatrix(3, 2) - projMatrix(2, 2) * projMatrix(3, 1)) + ...
		projMatrix(1, 1) * projMatrix(2, 2) - projMatrix(2, 1) * projMatrix(1, 2);
y = y / tmp;
x = y * (projMatrix(1, 2) - projMatrix(3, 2) * u) + c0 - c2 * u;
x = x / (projMatrix(3, 1) * u - projMatrix(1, 1)); 