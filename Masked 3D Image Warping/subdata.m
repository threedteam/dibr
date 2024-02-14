%% ��������ͼ���޸����������������ȿ�ʱ������ļ��㡣
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
% j = [0  0; 0  0];  %��ʼ������
% di = [ 0;0];   %��ʼ���ݶȾ���
% dit = [0 0]; %��ʼ���ݶȾ����ת��
dp = zeros(1,m);


for i= 1:m
    di= [ sobelx(i); sobely(i)]; %�����ݶȾ���
    dit = [sobelx(i) sobely(i)];%�����ݶȾ����ת�þ���
    j= di*dit; %��������
    E = eig(j); %������������ֵ
    t1 =  E(1);%�����ĵ�һ������ֵ
    t2 = E(2);%�����ĵڶ�������ֵ
    dp(i) = a + (1- a)*exp(-c/(t1-t2)^2); %��������
end


%     di= [ sobelx; sobely]; %�����ݶȾ���
%     dit = [sobelx sobely];%�����ݶȾ����ת�þ���
%     j= di*dit; %��������
%     E = eig(j); %������������ֵ
%     t1 =  E(1);%�����ĵ�һ������ֵ
%     t2 = E(2);%�����ĵڶ�������ֵ
%     dp = a + (1- a)*exp(-c/(t1-t2)^2); %��������

end
