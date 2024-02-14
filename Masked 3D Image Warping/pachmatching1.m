%% ��������ͼ���޸���������ѡ���޲��顣
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
%MP ���޲�����������ķǿյ��־��
%forinpanting ���޲���
%Forinpantingarea���޲������ڵ�����
%forinpantingd���޲����Ӧ�����ֵ��
%Forinpantingarea���޲������ڵ������Ӧ�����ֵ
[m ,n] = size(Forinpantingarea(:,:,1));

dR = zeros(m ,n); %��ʼ��R������sadֵ
dG = dR ;%��ʼ��G������sadֵ
dB = dR ;%��ʼ��B������sadֵ
dD = dR ;%��ʼ�����ֵ������sadֵ
d(1:m, 1:n) = inf ;%��ʼ��4��������sadֵ�ĺ�




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
