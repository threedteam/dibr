 %% 本程序是图像修复程序用来查找模板中深度值的最大值和最小值。
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

function [dmin, dmax] = findminmax(D)
[row, col] = find(D >0); 
i = length(row);
if i >0
dmin = D(row(1),col(1)); %初始化模板中的最小深度值
    dmax =  D(row(1),col(1));
else
    dmin = 0;
    dmax = 0;
end
    
    for j= 1:i
        if D(row(j) ,col(j))> dmax%统计模板中的最大值和最小值
            dmax = D(row(j) ,col(j));
        else
            if(D(row(j) ,col(j))< dmin)
                dmin =D(row(j) ,col(j));
            end
        end
    end