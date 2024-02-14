function [tx_mask] = morphology(rx_mask,rx_n)

Image = rx_mask;
% test
% Image=imread('result/mask1.png');
% figure,imshow(Image);title('原图像');
SE1=strel('square',rx_n);
SE2=strel('square',rx_n);

% 先闭运算后开运算
result1=imerode(imdilate(Image,SE2),SE2);
result2=imdilate(imerode(result1,SE1),SE1);

% 先开运算后闭运算
% result1=imdilate(imerode(Image,SE1),SE1);
% result2=imerode(imdilate(result1,SE2),SE2);

tx_mask = result2;




end