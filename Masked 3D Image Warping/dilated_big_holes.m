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
%     Filename         : dilated_big_holes.m
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-07-08 |  Hui Xie    |          Original
%          1.01    |  2018-09-16 |  Ran Liu    |          The function is changed
%   ------------------------------------------------------------------------
% \*=======================================================================

function [TX_sd, TX_ed] = dilated_big_holes(RX_M, RX_len_bighole, RX_sharp_th, RX_l, RX_rend_order, RX_Wi, RX_num, RX_u)
% DILATED_BIG_HOLES  return the horizontal coordinates of starting points and
% end points of current hole, and the disparity map value
% TX_sd: coordinate of the starting pixel of current hole in the destination image
% TX_ed: coordinate of the ending pixel of current hole in the destination image
% RX_M: disparity map
% RX_len_bighole: threshold of holes detection
% RX_sharp_th: threshold of sharp transitions
% RX_l: number of pixels that is to be dilate
% RX_rend_order: flag of the rending order of the reference image
% RX_Wi: image width
% RX_num: the number of contiue holes in the destination image
% RX_u: horizontal coordinate of the pixel

if RX_num >= RX_len_bighole % 较大空洞
    num_holes = 0; % num_holes: unsigned short
    lb_bk_fg = 0;
    if RX_rend_order == 0 % 右视图
        [TX_sd, TX_ed] = process_right_view(RX_u, RX_num, RX_M, RX_sharp_th, RX_l, num_holes, lb_bk_fg); % 处理右视图
    else  % 左视图
        [TX_sd, TX_ed] = process_left_view(RX_u, RX_num, RX_M, RX_sharp_th, RX_l, num_holes, lb_bk_fg, RX_Wi);
    end
else % 小空洞
    TX_sd = RX_u - RX_num; % 需要填充的目标图像的空洞起点
    TX_ed = RX_u - 1; % 需要填充的目标图像的空洞终点
end