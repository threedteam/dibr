%% ��������ͼ���޸����������������ȿ�ʱ���Ŷȵļ��㡣
%
% /*===========================================================================*\
%  This confidential and proprietary software may be used only by
%  authorized users by a licensing agreement from Panovasic Technology Co., Ltd.
%  In the event of publication, the following notice is applicable:
%   ========================================================================
%
%   PPPPPP    A      NN    N   OOOO  V       V   A      SSSS  IIIII  CCCCC
%   P    PP  A A     N N   N  O    O  V     V   A A    S        I   CC
%   PPPPPP  A   A    N  N  N  O    O   V   V   A   A    SSSS    I   CC
%   P      A A A A   N   N N  O    O    V V   A A A A       S   I   CC
%   P     A       A  N    NN   OOOO      V   A       A  SSSS  IIIII  CCCCC
%
%   ========================================================================
%     Filename         : confidence.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-19 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ c] =confidence(CM,D,th, h, w)%DΪ��άͼ��任���Ŀ��ͼ���Ӧ�����ͼ
%th����ǰ���ͱ����ķ�ֵ
%CM Ϊ���ŹŶȱ�ǣ��ն�ʱΪ0��ԭʼ�ǿյ�Ϊ1������С��1
D = double(D);
[row, col] = find(D >0);
if isempty(row)
    c = 0;
else
%    [dmin, dmax] = findminmax(D);
%     
%     if (dmax - dmin )> th; %ģ���д���ǰ����Ե
%         c = 0; %�������Ŷ�
%     else %ģ���в�����ǰ����Ե
        [ c] =subconfidence(CM ,h,w);
    end
end