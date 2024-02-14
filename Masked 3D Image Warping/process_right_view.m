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
%     Filename         : process_right_view.m
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-07-08 |  Hui Xie    |          Original
%          1.01    |  2018-09-16 |  Ran Liu    |          The function is changed
%   ------------------------------------------------------------------------
% \*=======================================================================

function [TX_sd, TX_ed] = process_right_view(RX_u, RX_num, RX_M, RX_sharp_th, RX_l, RX_num_holes, RX_lb_bk_fg)
% PROCESS_RIGHT_VIEW return the horizontal coordinates of starting points and
% end points of current hole
% TX_sd: coordinate of the starting pixel of current hole in the destination image
% TX_ed: coordinate of the ending pixel of current hole in the destination image
% RX_u: horizontal coordinate of the pixel
% RX_num: the number of contiue holes in the destination image
% RX_M: non-hole matrix
% RX_sharp_th: threshold of sharp transitions
% RX_l: number of pixels that is to be dilate
% RX_num_holes: number of non-hole pixels
% RX_lb_bk_fg: indicates whether the pixel is the pixel of the foreground or the background

% ��ʼ������ֵ
i = RX_u - RX_num - 1;

while RX_lb_bk_fg == 0
    if i > 1 % 1-based
        if RX_M(i- 1) ~= - 1  % �ǿն���
            if RX_M(i + RX_num_holes) - RX_M(i - 1) >= RX_sharp_th % �ն����Ե����Ϊǰ�����ص㣬ֻ���Ϳն��ұ�Ե��������ͼʱ�����ͼ���Ӳ�ͼֵ��Ԫ��ֵ�Ĵ�С���෴�ġ������ͼ�У�ǰ�����ص����ֵ���ڱ������ص����ֵ��
                RX_lb_bk_fg = 1;
                TX_sd = RX_u - RX_num;
                TX_ed = RX_u + RX_l - 1;             
            else
                if RX_M(i + RX_num_holes) - RX_M(i - 1) <= -RX_sharp_th  % �ն����Ե����Ϊ�������ص㣬�ն����߶���Ҫ����
                    RX_lb_bk_fg = 1;
                    TX_sd = RX_u - RX_num - RX_l;
                    TX_ed = RX_u  + RX_l - 1;
                else
                    RX_num_holes = 0 ;
                    i = i - 1;
                end
            end
        else  % �ն���
            RX_num_holes = RX_num_holes + 1;
            i = i - 1;
        end
    else
        % �ն����Ե����Ϊǰ�����ص㣬��ǰ�����ص�ǰ��û�б������ص�
        RX_lb_bk_fg = 1;
        TX_sd = RX_u - RX_num;
        TX_ed = RX_u + RX_l - 1;
    end
end




