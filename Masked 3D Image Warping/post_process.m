clc
clear

I = imread('Is_ballet_Out0.png');
%% 初始化参数
RX_Hi = size(I, 1);
RX_Wi = size(I, 2);
RX_Ides = I;

%% 中值滤波
for v = 1 : RX_Hi - 2
    for u = 1 : RX_Wi - 2
        win = RX_Ides(v : v + 2, u : u + 2, :);
            % 需要对RGB-“D”每一个分量分别进行滤波。这时有可能出现这样的现象：
            % 在选定每一个分量的中值时，有可能这些中值来自不同的像素。最后掩模对应的像素是多个像素的分量的组合。实验表明这一现象不会对滤波后的画质产生太大影响。
            win_reshape = reshape(win, 1, 9, 3);
            win_reshape = sort(win_reshape); % 找到中值（针对参考图像）
            TX_Ides(v + 1, u + 1, :) = win_reshape(1, 5, :); % 赋中值 
    end
end

imshow(TX_Ides);