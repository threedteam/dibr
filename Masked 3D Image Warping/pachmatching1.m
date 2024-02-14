%% 本程序是图像修复程序用来选择修补块。
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
function [ matching,dD1] =pachmatching(MP,Forinpantingarea,Forinpantingaread,h,w,th,maxp)
%MP 待修补块所在区域的非空点标志表
%forinpanting 待修补块
%Forinpantingarea待修补块所在的区域
%forinpantingd待修补块对应的深度值，
%Forinpantingarea待修补块所在的区域对应的深度值
[m ,n] = size(Forinpantingarea(:,:,1));

dR = zeros(m ,n); %初始化R分量的sad值
dG = dR ;%初始化G分量的sad值
dB = dR ;%初始化B分量的sad值
dD = dR ;%初始化深度值分量的sad值
d(1:m, 1:n) = inf ;%初始化4个分量的sad值的和




for i = ((h + 1)/2): (m - (h + 1)/2)
    for j = ((w + 1)/2):(n - (w + 1)/2)
        if (i~=(m+1)/2)&&(j ~=(n+1)/2 )
          [dmin, dmax] = findminmax(Forinpantingaread(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ) );
            if dmax > th
                d(i,j) = inf;
            else
                    dR(i, j)= sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingarea((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ,1),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingarea(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ,1) );
                    dB(i, j)= sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingarea((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ,2),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingarea(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ,2) );
                    dG(i, j)= sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingarea((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ,3),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingarea(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ,3) );
                    dD(i, j) = sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingaread((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingaread(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ) );
                    d(i, j) = dR(i, j) + dB(i, j) + dG(i, j)+ 0*dD(i, j);
            end
        end
    end
end


minsad = min(min( d ));
[row,col] = find(d == minsad);% figure;
if minsad == inf
    %     display(row);
    %     display(col);
    for i = ((h + 1)/2): (m - (h + 1)/2)
        for j = ((w + 1)/2):(n - (w + 1)/2)
            if (i~=(m+1)/2)&&(j ~=(n+1)/2 )
                dR(i, j)= sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingarea((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ,1),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingarea(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ,1) );
                dB(i, j)= sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingarea((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ,2),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingarea(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ,2) );
                dG(i, j)= sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingarea((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ,3),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingarea(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ,3) );
                dD(i, j) = sad(MP((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),Forinpantingaread((m+1)/2 - ((h -1)/2): (m+1)/2 + ((h -1)/2), (n+1)/2 - (w -1)/2 :  (n+1)/2 + (w -1)/2 ),MP(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ),Forinpantingaread(i - ((h -1)/2): i + ((h -1)/2), j - (w -1)/2 :  j + (w -1)/2 ) );
                d(i, j) = dR(i, j) + dB(i, j) + dG(i, j)+ 3*dD(i, j);
                
            else
                d(i, j) = inf;
            end
        end
    end
    minsad1 = min(min(d));
    [row,col] = find(d == minsad1);% figure;
    if minsad1 == inf
        row = n-(h + 1)/2;
        col = m-((w + 1)/2);
    end

end
matching(:,:, :) =  Forinpantingarea(row(1) - ((h -1)/2): row(1) + ((h -1)/2), col(1) - (w -1)/2 :col(1) + (w -1)/2 ,:);
dD1(:,:) = Forinpantingaread(row(1) - ((h -1)/2): row(1) + ((h -1)/2), col(1) - (w -1)/2 :col(1) + (w -1)/2 ,:);
end
