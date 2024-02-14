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
%     Corresponding author��Ran Liu
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
%% ��ʼ������
% N = [0 1 2 3 4 5 6 7 8];    % N��Ԫ�ر�ʾ�������������磬4��ʾģ�崰����������(v, u), 0��ʾ��һ�����ص������(v - 1, u - 1)

%% ɫ�ʿռ�ת��
rx_image = rgb2ycbcr(rx_image);
rx_image = double(rx_image);
Y = rx_image(:, :, 1);
Cb = rx_image(:, :, 2);
Cr = rx_image(:, :, 3);
%% ��ֵ�˲�
[Y, Cb, Cr] = MedianFilter(Y, Cb, Cr, Hi, Wi);

%% ����˲����ͼ��Ides
Y = uint8(Y);
Cb = uint8(Cb);
Cr = uint8(Cr);
rx_image = cat(3, Y, Cb, Cr);   % ͼ���ں�

tx_image = ycbcr2rgb(rx_image);
tx_image = uint8(tx_image);
end

