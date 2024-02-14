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

%%  这个函数将像素图像坐标系中的一点(u,v,1)映射到世界坐标系中的一点(x,y,z,1)，其中
%%  深度值z就是z坐标。

%  将坐标原点从左上角移动到左下角并使右手坐标系转换为左手坐标系的变换矩阵
%  在标定时，像素图像坐标系的原点假定在图像的左下角，以这种假定来
%  确定摄像机的内部参数矩阵。而最终得到的图像的像素图像坐标系以传统的
%  方式来表示，即原点在图像的左上角。因此这里要换算过来。
%  这里摄像机坐标系是左手坐标系。
%  多平移一个像素是为了与矩阵的行列的基数为1保持一致
Trl = [1 0  0   
       0 -1 m_Height - 1  
       0 0  1];  % 这里由于只是纯粹的计算，不用考虑基数为0还是为1的问题。
                 % 最后要生成图像时，或者要表示最初的图像时就应该考虑
   
newu = Trl * [u; v; 1];  
u = newu(1);
v = newu(2);

%  这些式子是由解方程得到的
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