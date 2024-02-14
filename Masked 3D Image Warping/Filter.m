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
%     Filename         :Filter .m
%     Description      : This program is used to eliminate small holes
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-11-26  |   Donghua Cao                 |   Original
%   ------------------------------------------------------------------------
% =========================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ tx_image ] = Filter(rx_image)
[Hi, Wi, n] = size(rx_image);
R = rx_image(:, :, 1);
G = rx_image(:, :, 2);
B = rx_image(:, :, 3);
%% 初始化参数
% N = [0 1 2 3 4 5 6 7 8];    % N中元素表示坐标索引，例如，4表示模板窗的中心坐标(v, u), 0表示第一个像素点的坐标(v - 1, u - 1)

%% 色彩空间转换
rx_image = rgb2ycbcr(rx_image);
rx_image = double(rx_image);
Y = rx_image(:, :, 1);
Cb = rx_image(:, :, 2);
Cr = rx_image(:, :, 3);
%% 中值滤波
[Y, Cb, Cr] = MedianFilter(Y, Cb, Cr, Hi, Wi);

%% 输出滤波后的图像Ides
Y = uint8(Y);
Cb = uint8(Cb);
Cr = uint8(Cr);
rx_image = cat(3, Y, Cb, Cr);   % 图像融合

tx_image = ycbcr2rgb(rx_image);
tx_image = uint8(tx_image);
end

