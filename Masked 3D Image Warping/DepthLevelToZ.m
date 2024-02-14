function z = DepthLevelToZ(d, MinZ, MaxZ)
%  DEPTHLEVELTOZ  Return the actual z (depth)
%  d is pixel value in the depth images. 
%  d represents depth, but is NOT the actual depth value.
%  This function returns actual z (depth)
%
%  ��Ȼ: liuran781101@tom.com
dd = double(d); % ����ת��Ϊ�߾���,�������Ľ����������ת��
z = 1.0 / ((dd / 255.0) * (1.0 / MinZ - 1.0 / MaxZ) + 1.0 / MaxZ);
