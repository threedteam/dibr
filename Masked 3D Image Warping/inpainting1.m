% =========================================================================================================
%       C Q UC Q UC Q UC Q U          C Q UC Q UC Q U              C Q U          C Q U
% C Q U               C Q U     C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q UC Q UC Q U     C Q U          C Q U          C Q U
% C Q U               C Q U     C Q U          C Q UC Q U          C Q U          C Q U
%      C Q UC Q UC Q U               C Q UC Q UC Q U                    C Q UC Q U
%                                              C Q UC Q U
%
%     (C) Copyright Chongqing University All Rights Reserved.
%
%     This program and corresponding materials are protected by software
%     copyright and patents.
%
%     Corresponding author��Ran Liu
%     Address: College of Computer Science, Chongqing University, 400044, Chongqing, P.R.China
%     Phone: +86 136 5835 8706
%     Fax: +86 23 65111874
%     Email: ran.liu_cqu@qq.com
%
%     Filename         :inpainting .m
%     Description      : This program is inpainting
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-11-26  |   Donghua Cao                 |   Original
%   ------------------------------------------------------------------------
% =========================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ I,Ddes] =inpanting1(Ides1,dD1,Wi1, Hi1,B,th,h, w,a,c,k)%DΪ��άͼ��任���Ŀ��ͼ���Ӧ�����ͼ
%dD Ŀ��ͼ���Ӧ�����ͼ
%th ����ǰ���ͱ����ķ�ֵ
%h,w�ֱ�Ϊ�޲���ĸߺͿ�
%a,c�ֱ�Ϊ��������ʱ�Ĳ���ֵ
%k Ϊk�����ȡֵ������ȡ5

Wi = Wi1 + k*w - 1;
Hi = Hi1 + k*h - 1;

confidences = zeros(Hi,Wi);
CM =double(confidences) ;
MP =double(confidences) ;

%��չ���ͼ  
dD =  zeros(Hi,Wi);%��չ���ͼ
dD(((k - 1)/2 )*h + (h + 1)/2: Hi - ((k - 1)/2)*h -(h - 1)/2,((k - 1)/2 )*w + (w + 1)/2 : 1: Wi - ((k - 1)/2)*w -(w - 1)/2) = dD1;
%  figure;
%  imshow(uint8(dD));
%��չ�����Ŀ��ͼ��
Ides =  zeros(Hi,Wi,3);
Ides(((k - 1)/2 )*h + (h + 1)/2: Hi - ((k - 1)/2)*h -(h - 1)/2,((k - 1)/2 )*w + (w + 1)/2 : 1: Wi - ((k - 1)/2)*w -(w - 1)/2,:) = Ides1;
%      figure;
%  imshow(uint8(Ides));
%��ʼ�����Ŷ�
for i= 1:Hi
    for j = Wi :-1:1
        if (dD(i,j) ~=0)
            CM(i,j) =1;
        end
    end
end

MP=CM;

flag = 1;
while (flag ==1)
 [ col,row] = findholestart1( MP ,Wi,Hi,k,h,w); %���ҿն������,

if (~isempty(row) )   
    [ Ides,CM,MP,dD] =subinpanting1(h, w,k,row(1),col(1),Wi,Hi,CM,dD,Ides,MP,th,a,c,B);%���������ȷ���Ŀն������Ƚ����޲��ĵ����ڵĿ飬�������޲�
    
%     imshow(uint8(Ides));
else   
    flag = 0;
end

end
I = Ides(((k - 1)/2 )*h + (h + 1)/2: Hi - ((k - 1)/2)*h -(h - 1)/2,((k - 1)/2 )*w + (w + 1)/2 : 1: Wi - ((k - 1)/2)*w -(w - 1)/2,:);
Ddes = dD(((k - 1)/2 )*h + (h + 1)/2: Hi - ((k - 1)/2)*h -(h - 1)/2,((k - 1)/2 )*w + (w + 1)/2 : 1: Wi - ((k - 1)/2)*w -(w - 1)/2,: );
end


     