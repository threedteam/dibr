%% 本程序是图像修复程序用来计算sad值。
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
%     Filename         : sad.m
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
function [ sad ] =sad(MPf,Forinpanting,MPc,candidate )
%MPf 待修补块的非空点标志表
%candidate 候选块
%MPc 候选块的非空点标志表
%Forinpanting待修补块
[m, n] = size(MPc);
d = zeros(m,n);
cont = 0;
cont1 = 0;
% MPc = ~MPc;

[row,col] = find(MPc ==0);
% l = length(row);
if isempty(row)  %修补块中没有空洞
    for i= 1:m
        for j = 1:n
            if (MPf(i,j) == 1)
                cont = cont + 1; %统计模板中非空点的个数
                d(i,j) = (Forinpanting(i,j) - candidate(i,j))^2; %计算两模块间非空像素点的差的平方
            else
                if MPc(i,j) == 1
                    cont1 = cont1 +1;
                end
                
            end
        end
    end
    if cont1>0  &&  cont>0    %候选块中含有待修补块中空洞点所对应位置的信息
        sad = sum(sum(d))/cont;
    else
        sad = inf;
    end
else
    sad = inf;
end
end
