% =========================================================================================================
%       C Q UC Q UC Q UC Q U          C Q UC Q UC Q U              C Q U          C Q U
% C Q U               C Q U     C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q UC Q UC Q U     C Q U          C Q U          C Q U
% C Q U               C Q U     C Q U          C Q UC Q U          C Q U          C Q U
%      C Q UC Q UC Q U               C Q UC Q UC Q U                    C Q UC Q U
%                                              C Q UC Q U
%
%     (C) Copyright Chongqing University All Rights Reserved. 
%
%     This program and corresponding materials are protected by software
%     copyright and patents.
%
%     Corresponding author：Ran Liu
%     Address: College of Computer Science, Chongqing University, 400044, Chongqing, P.R.China
%     Phone: +86 136 5835 8706
%     Fax: +86 23 65111874
%     Email: ran.liu_cqu@qq.com
%
%     Filename         : threed_image_warping.m
%     Description      : the function to perform 3D image warping
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-10-10  |   Donghua Cao                 |   Original
%         1.01     |  2014-10-18  |   Ran Liu                     |   The parameters of the function have been changed
%   ------------------------------------------------------------------------
% =========================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tx_ides, tx_m] = threed_image_warping(rx_iref, rx_d, rx_min_z, rx_max_z, rx_pr, rx_ides_rt, rx_ps)
% THREED_IMAGE_WARPING  Return the destination image and non-hole matrix
% tx_ides: generated destination image, uint8
% tx_m: generated non-hole matrix, double
%       -1: current point is a hole-point
%       [0, 255]: depth value of the current point
% rx_iref: reference image
% rx_d: depth map, uint8
% rx_min_z: minimum actual z (depth)
% rx_max_z: maximum actual z (depth)
% rx_pr: projection matrix of reference image, 4 x 4
% rx_ides_rt: affine transformation matrix of destination image, 3 x 4
% rx_ps: projection matrix of destination image, 4 x 4

%% 初始化参数
rx_d = rx_d(:, :, 1);
% image resolution is m_Width x Height,
% m_Height:图像的高
% m_Width:图像的宽
% Clr:图像的页
[m_Height, m_Width, Clr] = size(rx_iref);

% 从xoy到x'o'y'的坐标变换矩阵
Trl = [1 0  0
    0 -1 m_Height - 1
    0 0  1];  % 这里要考虑基数为0还是为1的问题，因为这里的坐标关系到了真实的图像坐标。
% 本程序采用的基数为0，与标定时采用的基数一致，在处理原始图像和最后生成图像时，需要转换基数（即要平移坐标系）

% 申请空间
tx_ides = uint8(zeros(m_Height, m_Width, Clr)); % 合成视图，uint8
tx_m(1 : m_Height, 1 : m_Width) = -1; % non-hole matrix, each element varies from -1 to 255. All elements are initialized to -1
% temp_m = zeros(m_Height, m_Width);
edge = zeros(m_Height, m_Width);

% 获取边缘标记
th_d = 18;  
th_e = 10;  %认定为边缘的阈值
temp_e = [rx_d(:, 2:m_Width), rx_d(:, m_Width)];
temp_e = double(temp_e) - double(rx_d);
edge(temp_e > th_e) = 1;
edge(:, 2:m_Width) = edge(:, 1:m_Width-1);
edge(:, 1) = 0;
edge(temp_e < -th_e) = 1;

% 计算目标图像tx_ides的外部参数矩阵
R_ides = rx_ides_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
T_ides = rx_ides_rt(:, 4); % 3 x 1

%% 根据参考图像rx_iref和深度图像rx_d进行三维图像变换，生成目标图像tx_ides
% 确定合成的目标图像tx_ides的边界
% tx_ides的4个顶点坐标依次为[0, 0, 1]'、[0, m_Height - 1, 1]'、[m_Width - 1, m_Height - 1, 1]'、[m_Width - 1, 0, 1]'（像素图像坐标系）
% 依次按逆时针排列
IsV = [0  0              m_Width - 1    m_Width - 1
    0  m_Height - 1   m_Height - 1   0
    1  1              1              1];
IsXV = [IsV(1, :), IsV(1, 1)]; % x坐标首尾相接构成一圈，确定了圈定的区域的边界
IsYV = [IsV(2, :), IsV(2, 1)]; % y坐标首尾相接构成一圈，确定了圈定的区域的边界，与x坐标对应
clear IsV; % 释放内存空间

% 计算目标图像对应的摄像机光心Cdes在参考图像rx_iref中的投影e
Ctmp = - inv(R_ides) * T_ides; % 根据T = -RC来计算C，3 x 3
Cdes = [Ctmp; 1]; % 变为齐次坐标，4 x 1
e = rx_pr * Cdes; % 投影矩阵是摄像机的内部参数矩阵，与世界坐标系的选择无关，只要按公式计算即可
e = e(1:3); % 变为二维齐次坐标
e = Trl \ e; % 从x'o'y'变换到xoy
ez = e(3); % the homogeneous element, 用于判断极点的极性
e = e / e(3); % 齐次化

% 根据e的坐标将rx_iref划分为若干个Sheet
[Sheets, ANo] = SubdivideRefImg(m_Width, m_Height, e);

% 遍历Sheets中的像素，将它们重投影到I3
if ez < 0   % 负极点
    % 待完善
else % 正极点，处理方向朝向极点
    % 确定遍历的顺序
    switch ANo
        case {'F'}
            % 处理Sheet1
            Rect = Sheets{1};
            for i = Rect(2) : Rect(4)  % 按行扫描
                for j = Rect(1) : Rect(3)
                    % 处理点[j; i; 1]
                    % 读取深度图上点[j; i; 1]的值
                    d = rx_d(i + 1, j + 1); % j + 1列，i + 1行。由于RGB分量都相同，就取其中一个, uint8
                    z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
                    % “Ballet”序列的深度图的深度值在量化时已经考虑了世界坐标系，各个视点的各个像素的z值都已经变换到了世界坐标系中
                    %  不需要再考虑从参考图像对应的摄像机的摄像机坐标系变换到世界坐标系
                    [x, y] = projUVZtoXY(m_Height, rx_pr, double(j), double(i), z); % 基数为0
                    [u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % 基数为0
                    u_round = round(u_double); v_round = round(v_double);
                    
                    % 判断[u, v]是否落在I1内
                    InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
                    if (InIs == 1)% 在才处理
                        if tx_m(v_round+1, u_round+1)<d+th_d
                            tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v_round+1, u_round+1) = round(d);
%                             temp_m(v_round+1, u_round+1) = 1;
                        end
                        if edge(i+1, j+1) == 1 || u_round+1 >= m_Width || u_round <= 0
                            continue;
                        end
                        % 水平补充
                        v = v_round;
                        u = u_round+1;
                        if tx_m(v+1, u+1)+th_d<d
                            tx_ides(v+1, u+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u+1) = round(d);
                        end
                        if tx_m(v+1, u-1)+th_d<d
                            tx_ides(v+1, u-1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u-1) = round(d);
                        end
%                         tx_ides(v + 1, u + 1, :) =  rx_iref(i + 1, j + 1, :);
%                         tx_m(v + 1, u + 1) = round(d); % 求解warped depth map时不需要坐标变换，直接拷贝即可。
                    end
                end
            end
            
            % 处理Sheet2
            Rect = Sheets{2};
            for i = Rect(4) : -1 : Rect(2)  % 按行扫描
                for j = Rect(1) : Rect(3)
                    % 处理点[j; i; 1]
                    % 读取深度图上点[j; i; 1]的值
                    d = rx_d(i + 1, j + 1); % j + 1列，i + 1行。由于RGB分量都相同，就取其中一个
                    z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
                    % “Ballet”序列的深度图的深度值在量化时已经考虑了世界坐标系，各个视点的各个像素的z值都已经变换到了世界坐标系中
                    %  不需要再考虑从参考图像对应的摄像机的摄像机坐标系变换到世界坐标系                    
                    [x, y] = projUVZtoXY(m_Height, rx_pr, double(j), double(i), z); % 基数为0
                    [u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % 基数为0
                    u_round = round(u_double); v_round = round(v_double);
                    
                    % 判断[u, v]是否落在I1内
                    InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
                    if (InIs == 1)% 在才处理
                        if tx_m(v_round+1, u_round+1)<d+th_d
                            tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v_round+1, u_round+1) = round(d);
%                             temp_m(v_round+1, u_round+1) = 1;
                        end
                        if edge(i+1, j+1) == 1 || u_round+1 >= m_Width || u_round <= 0
                            continue;
                        end
                        % 水平补充
                        v = v_round;
                        u = u_round+1;
                        if tx_m(v+1, u+1)+th_d<d
                            tx_ides(v+1, u+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u+1) = round(d);
                        end
                        if tx_m(v+1, u-1)+th_d<d
                            tx_ides(v+1, u-1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u-1) = round(d);
                        end
%                         tx_ides(v + 1, u + 1, :) =  rx_iref(i + 1, j + 1, :);
%                         tx_m(v + 1, u + 1) = round(d); % 求解warped depth map时不需要坐标变换，直接拷贝即可。
                    end
                end
            end
        otherwise
            disp('Unknow'); % 待进一步修改完善
    end
    %% show
%     figure(1);
%     imshow(tx_ides);
%     figure(2);
%     fig_m = tx_m;
%     fig_m(fig_m==-1)=0;
%     fig_m = uint8(fig_m);
%     imshow(fig_m);
%     figure(3)
%     imshow(rx_iref);
%     figure(4)
%     imshow(rx_d);
end;
