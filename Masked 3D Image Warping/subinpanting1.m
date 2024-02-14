
%% 本程序是图像修复程序用来寻找修复指定点的程序。
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
%     Filename         : subinpanting.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-05-09 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ Ides,CM,MP,dD] =subinpanting1(h, w,k,i,j,Wi,Hi,CM,dD,Ides,MP,th,a,c,B)
confidences = zeros(Hi,Wi);
datas = confidences;
% stopreturn = holedges;
p=zeros(Hi,Wi);
i1=i;
j1=j;

for i=(k -1)/2*h +(h+1)/2: Hi - ((k -1)/2)*h -(h+1)/2
    for j=((k-1)/2)*w +(w+1)/2+7:Wi-((k-1)/2)*w - (w+1)/2
    %               if  %判断是否越界
    %沿边缘计算置信度
    if B <0 %左视图
        if dD(i,j - 1) ~= 0&& dD(i,j + 1) == 0 %空洞左边缘
            confidences(i,j) =confidence(CM( i - (h-1)/2 :i + (h-1)/2 , j - (w-1)/2: j + (w-1)/2),dD( i - (h-1)/2 :i+ (h-1)/2 , j - (w-1)/2: j + (w-1)/2),th, h, w);%计算置信度
            datas(i,j)=data(Ides(i-1:i+1,j-1:j+1,:),dD(i-1:i+1,j-1:j+1) ,a, c);%计算数据项
        else
            confidences(i,j) = 0;
            datas(i,j) = 0;
        end
    else  %右视图
%         if dD(i,j+1) ~= 0&&dD(i,j -1) == 0 %空洞右边缘
   if dD(i,j-1) == 0&&dD(i,j) ~= 0 %空洞右边缘
            confidences(i,j) =confidence(CM( i - (h-1)/2 :i + (h-1)/2 , j - (w-1)/2: j + (w-1)/2),dD( i - (h-1)/2 :i+ (h-1)/2 , j - (w-1)/2: j + (w-1)/2),th, h, w);%计算置信度
            datas(i,j)=data(Ides(i-1:i+1,j-1:j+1,:),dD(i-1:i+1,j-1:j+1) ,a, c);%计算数据项
        else
            confidences(i,j) = 0;
            datas(i,j) = 0;
        end
    end
    p(i,j) = confidences(i,j)*datas(i,j);%计算优先级
    end
end
maxp = max( max(p)); %确定最大优先级
if maxp >0
[prow,pcol] = find( p ==maxp);%找到最大优先级所在块的位置
else
    prow = i1;
    pcol = j1;
end
i=prow(1)
j=pcol(1)
[matching(1:h,1:w,:),matchingd(1:h,1:w)]  = pachmatching1(MP(prow(1)-((k-1)/2)*h - (h-1)/2:prow(1)+((k-1)/2)*h + (h-1)/2 ,pcol(1)-((k-1)/2)*w -(w-1)/2:pcol(1)+((k-1)/2)*w + (w-1)/2),Ides(prow(1)-((k-1)/2)*h - (h-1)/2:prow(1)+((k-1)/2)*h + (h-1)/2 ,pcol(1)-((k-1)/2)*w -(w-1)/2:pcol(1)+((k-1)/2)*w + (w-1)/2,:),dD(prow(1)-((k-1)/2)*h - (h-1)/2:prow(1)+((k-1)/2)*h + (h-1)/2 ,pcol(1)-((k-1)/2)*w -(w-1)/2:pcol(1)+((k-1)/2)*w + (w-1)/2),h,w,th,maxp);
% figure;
% imshow(uint8(matching));
% if l ==0
 [Ides(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2,:),CM(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2), MP(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2),dD(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2)] = fillpach( matching,MP(prow(1)-(h-1)/2:prow(1)+(h-1)/2 ,pcol(1)-(w-1)/2:pcol(1)+(w-1)/2),Ides(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2,:),confidences(prow(1),pcol(1)),matchingd,dD(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2),CM(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2));
% else
%     holedges(prow(1),pcol(1))=2;
% end
% figure;
% imshow(uint8(Ides));
% figure;
% imshow(uint8(holedges *255));
% figure;
% imshow(uint8(MP*255));

% figure;
% imshow(uint8(CM*255));


end
        