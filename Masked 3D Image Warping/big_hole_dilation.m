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
%     Filename         : main.m
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-07-08 |  Hui Xie    |          Original
%          1.01    |  2018-09-16 |  Ran Liu    |          The function is changed
%   ------------------------------------------------------------------------
% \*=======================================================================


function [TX_Ides, TX_M]= big_hole_dilation(RX_Ides, RX_M, RX_len_bighole, RX_sharp_th, RX_l, RX_rend_order, RX_Wi, RX_Hi)
% BIG_HOLE_DILATION  dilate big holes in each destination image according to non-hole matrix to correct matching errors
% TX_Ides: destination image after big hole dilation
% TX_M: non-hole matrix after big hole dilation
% RX_Ides: destination image
% RX_M: input non-hole matrix, double
% RX_len_bighole: threshold for big hole detection
% RX_sharp_th: threshold for sharp transition
% RX_l: number of pixels that is to be dilate
% RX_rend_order: flag of the rending order of the reference image,
% 目标图像的绘制顺序，0表示从上到下，从左往右绘制(绘制右视图)；1表示从上到下，从右往左绘制(绘制左视图)
% RX_Wi: image width
% RX_Hi: image height



%% 初始化参数
TX_Ides = RX_Ides; % 预分配空间
TX_M = RX_M; % 预分配空间

v = 1; % 指示当前行的循环变量，1-based, unsigned short

while v <= RX_Hi % 1-based
    u = 2; % 指示当前列的循环变量，1-based
    while u <= RX_Wi % 1-based
  
%         for test        
%         if v == 220 && u == 339
%             disp([v, u]);
%         end
        
        
        %% 检测空洞
        % num: 中间变量，前面不加RX、TX前缀，表示当前空洞的边缘两个非空洞点中间的空洞点个数
        % u: 中间变量，前面不加RX、TX前缀，表示当前空洞的右边缘的第一个非空洞点的横坐标
        [num, u] = detect_holes(RX_M(v, :), RX_Wi, u); % [num, u]是函数返回的结果
        
        if num > 0 % 如果有空洞
            %% 确定大空洞的膨胀后的坐标,小空洞大小不变
            % sd: coordinate of the starting pixel of current hole in the destination image
            % ed: coordinate of the ending pixel of current hole in the destination image
            [sd, ed] = dilated_big_holes(RX_M(v, :), RX_len_bighole, RX_sharp_th, RX_l, RX_rend_order, RX_Wi, num, u);
            
            %% 执行膨胀动作，膨胀是在新的变量TX_M中实现的，输入变量RX_M不变。
            if  sd > 2 && ed < RX_Wi % 判断是否越界，1-based
                TX_Ides(v, sd : ed, :) = 0; % 目标图像像素值赋值为0；
                TX_M(v, sd : ed) = -1; % 对应的非空洞矩阵中的值变为-1，即改为空洞；
            end
        end
        u = u + 1;
    end
    v = v + 1;
end