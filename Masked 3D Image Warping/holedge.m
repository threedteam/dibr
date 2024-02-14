%% ��������ͼ���޸���������ȷ���ն���Ե�ĳ���
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
%     Filename         : holedge.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-23 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ holedge] = holedge(dD,Wi, Hi)
%dD Ŀ��ͼ���Ӧ�����ͼ
%M �ն����ͼ
holedge1 = zeros(Hi,Wi);
%%ȷ����Ե
definedges= definedge(dD,Wi, Hi);
    figure;
    imshow(uint8(definedges*255));

for i= 1:Hi
    for j = Wi:-1:1
%         if (dD(i,j) == -1)%�ն���
        if (dD(i,j) == 0)%�ն���
            if (definedges(i ,j) == 1)%��Ե����
                holedge1(i,j) = 1;
            end
        end
    end
end

figure;
    imshow(uint8(holedge1*255));

%%�����ٱ�Ե
holedge = holedge1;
for i= 2:Hi -1
    for j = Wi - 1:-1:2
        if (dD(i,j - 1) == 0)&&(dD(i,j + 1) == 0)&&(dD(i-1,j ) == 0)&&(dD(i+1,j ) == 0)&&(holedge1(i,j) == 1)
            holedge(i,j) = 0;
        end
    end
end
end
