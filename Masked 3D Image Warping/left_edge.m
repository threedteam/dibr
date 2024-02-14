clc
clear
for i=0:99
    I = imread(['edge_ballet/Is_ballet_edge',num2str(i),'.png']);
    [m,n]=size(I);
    I=~I;
    imwrite(I, ['edge1_ballet/Is_ballet_edge',num2str(i),'.png']);
end
% I=rgb2gray(I);
% [m,n]=size(I);
% edg=zeros(m,n);
% move=[edg(:,1:4),I(:,1:n-4)];

% BW1 = edge(I,'canny',0.7);  % µ÷ÓÃcannyº¯Êý
% imshow(BW1)
% FileName = strcat('guide1.png');
% imwrite(move, FileName);

% [m,n]=size(I);
% edg=zeros(m,n);
% for i=2:m-1
%     for j=2:n-1
%         if I(i,j)==1 && I(i,j-1)==0 && I(i,j+1)==1
%             edg(i,j)=1;
%         end
%     end
% end
% imshow(edg)