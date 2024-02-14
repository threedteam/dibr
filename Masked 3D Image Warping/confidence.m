%% 本程序是图像修复程序用来计算优先块时置信度的计算。
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
function [ c] =confidence(CM,D,th, h, w)%D为三维图像变换后的目标图像对应的深度图
%th区分前景和背景的阀值
%CM 为置信古度标记，空洞时为0，原始非空点为1，填充点小于1
D = double(D);
[row, col] = find(D >0);
if isempty(row)
    c = 0;
else
%    [dmin, dmax] = findminmax(D);
%     
%     if (dmax - dmin )> th; %模板中存在前景边缘
%         c = 0; %计算置信度
%     else %模板中不存在前景边缘
        [ c] =subconfidence(CM ,h,w);
    end
end