function [Sheets, ANo] = SubdivideRefImg(m_Width, m_Height, e)
%  SUBDIVIDEREFIMG   subdivide the reference image into sheets
%  m_Width: the width of the reference image
%  m_Height: the height of the reference image
%  e: the epipole，采用规范化齐次坐标
%  ANo: 区域标识符
%  Sheets: 元包数组
% 
%  Ran Liu: liuran781101@tom.com
%  College of Computer Science, Chongqing University
%  Panovasic Technology Co.,Ltd

% 本函数中图像的像素图像坐标系采用的基数为0，即图像原点为(0, 0)
% Sheet = [TopLeftX, TopLeftY, BottomRightX, BottomRightY];
% Sheet之间采用[闭，开)方式
w = m_Width - 1;
h = m_Height - 1;
ex = round(e(1));
ey = round(e(2));
if ex < 0
    if ey < 0  %  落在区域A
        Sheet1 = [0, 0, w, h];
        Sheets(1) = {Sheet1};
        ANo = 'A';
    else 
        if ey <= h  %  落在区域D
            Sheet1 = [0, 0, w, ey - 1];
            Sheet2 = [0, ey, w, h];
            Sheets(1) = {Sheet1};
            Sheets(2) = {Sheet2};
            ANo = 'D';
        else  %  落在区域G
            Sheet1 = [0, 0, w, h];
            Sheets(1) = {Sheet1};  
            ANo = 'G';
        end
    end
else
    if ex <= w
        if ey < 0 % 落在区域B
            Sheet1 = [0, 0, ex - 1, h]; 
            Sheet2 = [ex, 0, w, h];
            Sheets(1) = {Sheet1};
            Sheets(2) = {Sheet2};
            ANo = 'B';
        else
            if ey <= h  %  落在区域E
                Sheet1 = [0, 0, ex - 1, ey - 1]; 
                Sheet2 = [ex, 0, w, ey - 1];
                Sheet3 = [0, ey, ex - 1, h];
                Sheet4 = [ex - 1, ey - 1, w, h];
                Sheets(1) = {Sheet1};
                Sheets(2) = {Sheet2};  
                Sheets(3) = {Sheet3};
                Sheets(4) = {Sheet4};
                ANo = 'E';
            else % 落在区域H
                Sheet1 = [0, 0, ex - 1, h]; 
                Sheet2 = [ex, 0, w, h];
                Sheets(1) = {Sheet1};
                Sheets(2) = {Sheet2};
                ANo = 'H';
            end
        end
    else
        if ey < 0 % 落在区域C
            Sheet1 = [0, 0, w, h]; 
            Sheets(1) = {Sheet1};
            ANo = 'C';
        else
            if ey <= h  % 落在区域F
                Sheet1 = [0, 0, w, ey - 1];
                Sheet2 = [0, ey, w, h];
                Sheets(1) = {Sheet1};
                Sheets(2) = {Sheet2};  
                ANo = 'F';
            else % 落在区域I
                Sheet1 = [0, 0, w, ey];
                Sheets(1) = {Sheet1};
                ANo = 'I';
            end
        end
    end
end;
