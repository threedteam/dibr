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
%     Corresponding author£ºRan Liu
%     Address: College of Computer Science, Chongqing University, 400044, Chongqing, P.R.China
%     Phone: +86 136 5835 8706
%     Fax: +86 23 65111874
%     Email: ran.liu_cqu@qq.com
%
%     Filename         : detect_holes.m
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-07-08 |  Hui Xie    |          Original
%          1.01    |  2018-09-16 |  Ran Liu    |          the 
%   ------------------------------------------------------------------------
% \*=======================================================================

function [TX_num, TX_u] = detect_holes(RX_M, RX_Wi, RX_u)
% DETECT_HOLES  Return the number of the continuate holes in destination
% image and the horizontal coordinate of the terminal hole
% RX_M: non-hole matrix/disparity map
% RX_Wi: image width
% RX_v: vertical coordinate of the pixel
% RX_u: horizontal coordinate of the pixel
% TX_num: number of the holes between two non-hole pixels

TX_num = 0;

while RX_u < RX_Wi && RX_M(RX_u) == -1 % ¼ì²â¿Õ¶´
    TX_num = TX_num + 1;
    
    RX_u = RX_u + 1;
end

TX_u = RX_u;

