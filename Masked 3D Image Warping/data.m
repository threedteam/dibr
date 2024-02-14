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
%     Filename         : data.m
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
function [ dp ] =data(I,dD ,a, c)
%a,c分别为求数据项时的参数值

%%求图像R分量数据项的值
sobelxr = sobelx(I(:,:,1));
sobelyr = sobely(I(:,:,1));
datar = subdata(sobelxr,sobelyr,a, c);

%%求图像G分量数据项的值
sobelxg = sobelx(I(:,:,2));
sobelyg = sobely(I(:,:,2));
datag = subdata(sobelxg,sobelyg,a, c);

%%求图像B分量数据项的值
sobelxb = sobelx(I(:,:,3));
sobelyb = sobely(I(:,:,3));
datab = subdata(sobelxb,sobelyb,a, c);


%%求深度图象分量数据项的值
sobelxd = sobelx(dD);
sobelyd = sobely(dD);
datad = subdata(sobelxd,sobelyd,a, c);


dp = datar + datab + datag +datad;

end
