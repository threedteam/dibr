clc
clear

I = imread('Is_ballet_Out0.png');
%% ��ʼ������
RX_Hi = size(I, 1);
RX_Wi = size(I, 2);
RX_Ides = I;

%% ��ֵ�˲�
for v = 1 : RX_Hi - 2
    for u = 1 : RX_Wi - 2
        win = RX_Ides(v : v + 2, u : u + 2, :);
            % ��Ҫ��RGB-��D��ÿһ�������ֱ�����˲�����ʱ�п��ܳ�������������
            % ��ѡ��ÿһ����������ֵʱ���п�����Щ��ֵ���Բ�ͬ�����ء������ģ��Ӧ�������Ƕ�����صķ�������ϡ�ʵ�������һ���󲻻���˲���Ļ��ʲ���̫��Ӱ�졣
            win_reshape = reshape(win, 1, 9, 3);
            win_reshape = sort(win_reshape); % �ҵ���ֵ����Բο�ͼ��
            TX_Ides(v + 1, u + 1, :) = win_reshape(1, 5, :); % ����ֵ 
    end
end

imshow(TX_Ides);