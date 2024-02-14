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
%     Filename         : MedianFilter.m
%     Author           : Guoqin Tai
%     Description      : This program is used to eliminate matching errors
%     of destination image by median filter
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author        | Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-05-25 |  Guoqin Tai    | Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*===========================================================================*/

function [Y, Cb, Cr] = MedianFilter(Y, Cb, Cr, Hi, Wi)
% win = zeros(3, 3);
% temp1 = 0;    %   中间变量
% temp2 = 0;
for v = 1 : Hi - 2
% v = 320;
    for u = 1 : Wi - 2
N = [0 1 2 3 4 5 6 7 8]; 
        win_Y = Y(v : v + 2, u : u + 2);
%         win_Cb = Cb(v : v + 2, u : u + 2);
        win_Y_reshape = reshape(win_Y, 1, 9);
%         win_Cb_reshape =reshape(win_Cb, 1, 9);
        for i = 1 : 5
            for j = 1 : 8
                if win_Y_reshape(j) > win_Y_reshape(j + 1)      %冒泡法排序
                    temp1 = win_Y_reshape(j);
                    win_Y_reshape(j) = win_Y_reshape(j + 1);
                    win_Y_reshape(j + 1) = temp1;
%                 if win_Cb_reshape(j) > win_Cb_reshape(j + 1)      %冒泡法排序
%                     temp2 = win_Cb_reshape(j);
%                     win_Cb_reshape(j) = win_Cb_reshape(j + 1);
%                     win_Cb_reshape(j + 1) = temp2;
%                 end
                    temp2 = N(j);
                    N(j) = N(j + 1);
                    N(j + 1) = temp2;
               end
            end
        end
%         end
        Y(v + 1, u + 1) = win_Y_reshape(5);
%         Cb(v + 1, u + 1) = win_Cb_reshape(5);
        switch N(5)
            case 0
                Cb(v + 1, u + 1) = Cb(v, u);
                Cr(v + 1, u + 1) = Cr(v, u);
            case 1
                Cb(v + 1, u + 1) = Cb(v + 1, u);
                Cr(v + 1, u + 1) = Cr(v + 1, u);
            case 2
                Cb(v + 1, u + 1) = Cb(v + 2, u);
                Cr(v + 1, u + 1) = Cr(v + 2, u);
            case 3
                Cb(v + 1, u + 1) = Cb(v, u + 1);
                Cr(v + 1, u + 1) = Cr(v, u + 1);
            case 4
                Cb(v + 1, u + 1) = Cb(v + 1, u + 1);
                Cr(v + 1, u + 1) = Cr(v + 1, u + 1);
            case 5
                Cb(v + 1, u + 1) = Cb(v + 2, u + 1);
                Cr(v + 1, u + 1) = Cr(v + 2, u + 1);
            case 6
                Cb(v + 1, u + 1) = Cb(v, u + 2);
                Cr(v + 1, u + 1) = Cr(v, u + 2);
            case 7
                Cb(v + 1, u + 1) = Cb(v + 1, u + 2);
                Cr(v + 1, u + 1) = Cr(v + 1, u + 2);
            case 8
                Cb(v + 1, u + 1) = Cb(v + 2, u + 2);
                Cr(v + 1, u + 1) = Cr(v + 2, u + 2);
        end
    end
end
                    
                    
        