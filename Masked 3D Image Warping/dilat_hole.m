clc
clear
for i=0:99
    I = imread(['M_ballet/Is_ballet_M',num2str(i),'.png']);
    se1=strel('disk',1);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
    se2=strel('disk',2);
    se3=strel('disk',3);
    se10=strel('disk',10);
    I1=imerode(I,se3);
    I1=imerode(I1,se2);
    I1=imerode(I1,se1);
    I2=imdilate(I1,se10);
    I2=imdilate(I2,se10);
    I2=imdilate(I2,se10);
    I3=I2+I;
    imwrite(I3, ['M_ballet_big/Is_ballet_big_mask',num2str(i),'.png']);
end