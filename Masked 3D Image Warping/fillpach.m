%% ��������ͼ���޸������������ն���������ͼ��ı�Ե��
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

%matching��ѡ��
%MP1  ��ѡ��ķǿյ��־��,ͬʱ����Ե��չһ������
%Forinpanting���޲���
%cΪ�������ĵ�����Ŷ�
%MP ���������µķǿյ��־��
%upholedges ���º�Ŀն���Ե
%CM���º�����ű�
%Ides �޲����ͼ��



[m, n] = size(MP);%%MP�Ŀ���Լ����ȱ�matching��4������
CM =  CM1;
I = Ides;
dD1 = dD;

for i= 1:m
    for j = 1:n 
        if (MP(i,j) == 0)&&(matchingd(i,j)>0)
            I(i  ,j ,:) = matching(i ,j ,:); %���ն��㣬�ǿ����ص㱣�ֲ���
            CM(i ,j ) = c;%�������Ŷ�
            dD1(i, j ) = matchingd(i ,j );
            MP(i ,j ) = 1;%���·ǿձ�
        end
    end
end

    
end
