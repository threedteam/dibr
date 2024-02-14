%% 本程序是图像修复程序用来寻找修复起点的程序。
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
%     Filename         : findholestart.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-05-09 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ row,col ] = findholestart1( M,Wi,Hi,k,h,w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   
    E = zeros(Hi, Wi);


    for i = ((k - 1)/2 )*h + (h + 1)/2 + 1 : Hi - ((k - 1)/2)*h -(h + 1)/2
        for j = ((k - 1)/2 )*w + (w + 1)/2 + 1: 1: Wi - ((k - 1)/2)*w -(w + 1)/2
           if (M(i,j)==0)
            E(i,j) = 1;
           end
        end
    end
    F = E'; %将源图像转置
[row,col] = find(F ,1); %find函数按列来寻找,本程序设计按行来寻找，所以需要将原图像转置
end

