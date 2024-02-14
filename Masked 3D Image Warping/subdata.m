%% 本程序是图像修复程序用来计算优先块时数据项的计算。
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
%     Filename         : subdata.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-18 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ dp ] =subdata(sobelx,sobely ,a, c)
m = length(sobelx);
% j = [0  0; 0  0];  %初始化张量
% di = [ 0;0];   %初始化梯度矩阵
% dit = [0 0]; %初始化梯度矩阵的转置
dp = zeros(1,m);


for i= 1:m
    di= [ sobelx(i); sobely(i)]; %计算梯度矩阵
    dit = [sobelx(i) sobely(i)];%计算梯度矩阵的转置矩阵
    j= di*dit; %计算张量
    E = eig(j); %求张量的特征值
    t1 =  E(1);%张量的第一个特征值
    t2 = E(2);%张量的第二个特征值
    dp(i) = a + (1- a)*exp(-c/(t1-t2)^2); %求数据项
end


%     di= [ sobelx; sobely]; %计算梯度矩阵
%     dit = [sobelx sobely];%计算梯度矩阵的转置矩阵
%     j= di*dit; %计算张量
%     E = eig(j); %求张量的特征值
%     t1 =  E(1);%张量的第一个特征值
%     t2 = E(2);%张量的第二个特征值
%     dp = a + (1- a)*exp(-c/(t1-t2)^2); %求数据项

end
