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
% Ŀ��ͼ��Ļ���˳��0��ʾ���ϵ��£��������һ���(��������ͼ)��1��ʾ���ϵ��£������������(��������ͼ)
% RX_Wi: image width
% RX_Hi: image height



%% ��ʼ������
TX_Ides = RX_Ides; % Ԥ����ռ�
TX_M = RX_M; % Ԥ����ռ�

v = 1; % ָʾ��ǰ�е�ѭ��������1-based, unsigned short

while v <= RX_Hi % 1-based
    u = 2; % ָʾ��ǰ�е�ѭ��������1-based
    while u <= RX_Wi % 1-based
  
%         for test        
%         if v == 220 && u == 339
%             disp([v, u]);
%         end
        
        
        %% ���ն�
        % num: �м������ǰ�治��RX��TXǰ׺����ʾ��ǰ�ն��ı�Ե�����ǿն����м�Ŀն������
        % u: �м������ǰ�治��RX��TXǰ׺����ʾ��ǰ�ն����ұ�Ե�ĵ�һ���ǿն���ĺ�����
        [num, u] = detect_holes(RX_M(v, :), RX_Wi, u); % [num, u]�Ǻ������صĽ��
        
        if num > 0 % ����пն�
            %% ȷ����ն������ͺ������,С�ն���С����
            % sd: coordinate of the starting pixel of current hole in the destination image
            % ed: coordinate of the ending pixel of current hole in the destination image
            [sd, ed] = dilated_big_holes(RX_M(v, :), RX_len_bighole, RX_sharp_th, RX_l, RX_rend_order, RX_Wi, num, u);
            
            %% ִ�����Ͷ��������������µı���TX_M��ʵ�ֵģ��������RX_M���䡣
            if  sd > 2 && ed < RX_Wi % �ж��Ƿ�Խ�磬1-based
                TX_Ides(v, sd : ed, :) = 0; % Ŀ��ͼ������ֵ��ֵΪ0��
                TX_M(v, sd : ed) = -1; % ��Ӧ�ķǿն������е�ֵ��Ϊ-1������Ϊ�ն���
            end
        end
        u = u + 1;
    end
    v = v + 1;
end