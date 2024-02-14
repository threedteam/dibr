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
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-10-28  |   Donghua Cao                 |   Original
%         1.01     |  2014-10-28  |   Ran Liu                     |   The code style has been changed
%         1.02     |  2018-09-15  |   Ran Liu                     |   Modules of median filtering and big hole dilation have been added
%   ------------------------------------------------------------------------
% =========================================================================================================
clc
clear
% ȫ�ֱ���
local_path = 'G:\eclipse\Spatio-temporal Hole-filling for DIBR System\code\proposed_method_debug\breakdancers\';
for idx = 0 : 99
        FileName = strcat(local_path, 'Ides_breakdancers\','Is_breakdancers_des', int2str(idx), '.png');
        IR = imread(FileName);
        % ��ȡIR��Ӧ�����ͼ
        FileName = strcat(local_path, 'M_breakdancers\', 'Is_breakdancers_m', int2str(idx), 'M');
        D = dlmread(FileName);
        
    hi = size(IR, 1);
    wi = size(IR, 2);
    [Ides, M] = median_filtering(IR, D, wi, hi);
    %% �ڰ׷�ת:��ת��0����ǿ����ص㣬1����ն����ص�
    M(M ~= -1) = 1;
    M(M == -1) = 0;
    for i = 1 : hi
        ind = find(M(i,:) == 0);
        Ides(i, ind, :) = 255;
    end
        M =~ M;
    %% �������ͼ���ն�����Ϊ255
%     M(M == -1) = 255;
%     M=uint8(M);
    %% ����big hole dilation��Ľ��
    FileName_Ides = strcat('Ides_filter_breakdancers/Is_breakdancers_des', int2str(idx), '.png');
    imwrite(Ides, FileName_Ides);
    FileName_M = strcat('M_filter_breakdancers/Is_breakdancers_M', int2str(idx), '.png');
    imwrite(M, FileName_M);    
end