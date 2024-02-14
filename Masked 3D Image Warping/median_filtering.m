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

%     Filename         : median_filtering.m
%     Description      : This program is used to eliminate part of some holes 
%     in destination image by the proposed median filtering algorithm
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author        | Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-05-25 |  Guoqin Tai     | Original
%          1.01    |  2018-09-15 |  Yangting Zhen  | the disparity map is changed to non-hole matrix
%   ------------------------------------------------------------------------
%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved
% \*===========================================================================*/

function [TX_Ides, TX_M] = median_filtering(RX_Ides, RX_M, RX_Wi, RX_Hi)
% MEDIAN_FILTERING  return the destination image filtered by the
% proposed median filter
% TX_Ides: the destination image after median filtering
% TX_M: the non-hole matrix corresponding to the filtered destination image, double
% RX_Ides: destination image genetated by 3D image warping algorithm, uint8
% RX_M: non-hole matrix generated by 3D image warping algorithm, double
%       -1: indiate that current point is a hole-point
%       [0, 255]: indiate the depth value of the current point
% RX_Wi: image width
% RX_Hi: image height

%% ��ʼ������
TX_Ides = RX_Ides;
TX_M = RX_M;

%% ��ֵ�˲�
for v = 1 : RX_Hi - 2
    for u = 1 : RX_Wi - 2
        n = 0;
        win = RX_Ides(v : v + 2, u : u + 2, :);
        win_M  = RX_M(v : v + 2, u : u + 2);
        
        for i = 0 : 2
            for j = 0 : 2
                if win_M(i + 1, j + 1) == -1  % ͳ����ģ�еĿն���
                    n = n + 1;
                end
            end
        end
        if n < 5
            % ��Ҫ��RGB-��D��ÿһ�������ֱ�����˲�����ʱ�п��ܳ�������������
            % ��ѡ��ÿһ����������ֵʱ���п�����Щ��ֵ���Բ�ͬ�����ء������ģ��Ӧ�������Ƕ�����صķ�������ϡ�ʵ�������һ���󲻻���˲���Ļ��ʲ���̫��Ӱ�졣
            win_reshape = reshape(win, 1, 9, 3);
            win_reshape = sort(win_reshape); % �ҵ���ֵ����Բο�ͼ��
            TX_Ides(v + 1, u + 1, :) = win_reshape(1, 5, :); % ����ֵ
            
            win_M_reshape = reshape(win_M, 1, 9);
            win_M_reshape = sort(win_M_reshape); % �ҵ���ֵ����Էǿն�����
            TX_M(v + 1, u + 1, :) = win_M_reshape(1, 5); % ����ֵ
        end
    end
end