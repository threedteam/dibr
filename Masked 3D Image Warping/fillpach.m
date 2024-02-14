%% 本程序是图像修复程序用来填充空洞，并更新图像的边缘。
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
%     Filename         : fillpach.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-26 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ I,CM,MP,dD1] =fillpach(matching,MP,Ides,c,matchingd,dD,CM1)

%matching候选块
%MP1  候选块的非空点标志表,同时将边缘扩展一个像素
%Forinpanting待修补块
%c为填充块中心点的置信度
%MP 完成填充后更新的非空点标志表
%upholedges 更新后的空洞边缘
%CM更新后的置信表
%Ides 修补后的图像



[m, n] = size(MP);%%MP的宽度以及长度比matching大4个像素
CM =  CM1;
I = Ides;
dD1 = dD;

for i= 1:m
    for j = 1:n 
        if (MP(i,j) == 0)&&(matchingd(i,j)>0)
            I(i  ,j ,:) = matching(i ,j ,:); %填充空洞点，非空像素点保持不变
            CM(i ,j ) = c;%更新置信度
            dD1(i, j ) = matchingd(i ,j );
            MP(i ,j ) = 1;%更新非空表
        end
    end
end

    
end
