function [Sheets, ANo] = SubdivideRefImg(m_Width, m_Height, e)
%  SUBDIVIDEREFIMG   subdivide the reference image into sheets
%  m_Width: the width of the reference image
%  m_Height: the height of the reference image
%  e: the epipole�����ù淶���������
%  ANo: �����ʶ��
%  Sheets: Ԫ������
% 
%  Ran Liu: liuran781101@tom.com
%  College of Computer Science, Chongqing University
%  Panovasic Technology Co.,Ltd

% ��������ͼ�������ͼ������ϵ���õĻ���Ϊ0����ͼ��ԭ��Ϊ(0, 0)
% Sheet = [TopLeftX, TopLeftY, BottomRightX, BottomRightY];
% Sheet֮�����[�գ���)��ʽ
w = m_Width - 1;
h = m_Height - 1;
ex = round(e(1));
ey = round(e(2));
if ex < 0
    if ey < 0  %  ��������A
        Sheet1 = [0, 0, w, h];
        Sheets(1) = {Sheet1};
        ANo = 'A';
    else 
        if ey <= h  %  ��������D
            Sheet1 = [0, 0, w, ey - 1];
            Sheet2 = [0, ey, w, h];
            Sheets(1) = {Sheet1};
            Sheets(2) = {Sheet2};
            ANo = 'D';
        else  %  ��������G
            Sheet1 = [0, 0, w, h];
            Sheets(1) = {Sheet1};  
            ANo = 'G';
        end
    end
else
    if ex <= w
        if ey < 0 % ��������B
            Sheet1 = [0, 0, ex - 1, h]; 
            Sheet2 = [ex, 0, w, h];
            Sheets(1) = {Sheet1};
            Sheets(2) = {Sheet2};
            ANo = 'B';
        else
            if ey <= h  %  ��������E
                Sheet1 = [0, 0, ex - 1, ey - 1]; 
                Sheet2 = [ex, 0, w, ey - 1];
                Sheet3 = [0, ey, ex - 1, h];
                Sheet4 = [ex - 1, ey - 1, w, h];
                Sheets(1) = {Sheet1};
                Sheets(2) = {Sheet2};  
                Sheets(3) = {Sheet3};
                Sheets(4) = {Sheet4};
                ANo = 'E';
            else % ��������H
                Sheet1 = [0, 0, ex - 1, h]; 
                Sheet2 = [ex, 0, w, h];
                Sheets(1) = {Sheet1};
                Sheets(2) = {Sheet2};
                ANo = 'H';
            end
        end
    else
        if ey < 0 % ��������C
            Sheet1 = [0, 0, w, h]; 
            Sheets(1) = {Sheet1};
            ANo = 'C';
        else
            if ey <= h  % ��������F
                Sheet1 = [0, 0, w, ey - 1];
                Sheet2 = [0, ey, w, h];
                Sheets(1) = {Sheet1};
                Sheets(2) = {Sheet2};  
                ANo = 'F';
            else % ��������I
                Sheet1 = [0, 0, w, ey];
                Sheets(1) = {Sheet1};
                ANo = 'I';
            end
        end
    end
end;
