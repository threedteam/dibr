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
%     Filename         : threed_image_warping.m
%     Description      : the function to perform 3D image warping
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-10-10  |   Donghua Cao                 |   Original
%         1.01     |  2014-10-18  |   Ran Liu                     |   The parameters of the function have been changed
%   ------------------------------------------------------------------------
% =========================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tx_ides, tx_m] = threed_image_warping(rx_iref, rx_d, rx_min_z, rx_max_z, rx_pr, rx_ides_rt, rx_ps)
% THREED_IMAGE_WARPING  Return the destination image and non-hole matrix
% tx_ides: generated destination image, uint8
% tx_m: generated non-hole matrix, double
%       -1: current point is a hole-point
%       [0, 255]: depth value of the current point
% rx_iref: reference image
% rx_d: depth map, uint8
% rx_min_z: minimum actual z (depth)
% rx_max_z: maximum actual z (depth)
% rx_pr: projection matrix of reference image, 4 x 4
% rx_ides_rt: affine transformation matrix of destination image, 3 x 4
% rx_ps: projection matrix of destination image, 4 x 4

%% ��ʼ������
rx_d = rx_d(:, :, 1);
% image resolution is m_Width x Height,
% m_Height:ͼ��ĸ�
% m_Width:ͼ��Ŀ�
% Clr:ͼ���ҳ
[m_Height, m_Width, Clr] = size(rx_iref);

% ��xoy��x'o'y'������任����
Trl = [1 0  0
    0 -1 m_Height - 1
    0 0  1];  % ����Ҫ���ǻ���Ϊ0����Ϊ1�����⣬��Ϊ����������ϵ������ʵ��ͼ�����ꡣ
% ��������õĻ���Ϊ0����궨ʱ���õĻ���һ�£��ڴ���ԭʼͼ����������ͼ��ʱ����Ҫת����������Ҫƽ������ϵ��

% ����ռ�
tx_ides = uint8(zeros(m_Height, m_Width, Clr)); % �ϳ���ͼ��uint8
tx_m(1 : m_Height, 1 : m_Width) = -1; % non-hole matrix, each element varies from -1 to 255. All elements are initialized to -1
% temp_m = zeros(m_Height, m_Width);
edge = zeros(m_Height, m_Width);

% ��ȡ��Ե���
th_d = 18;  
th_e = 10;  %�϶�Ϊ��Ե����ֵ
temp_e = [rx_d(:, 2:m_Width), rx_d(:, m_Width)];
temp_e = double(temp_e) - double(rx_d);
edge(temp_e > th_e) = 1;
edge(:, 2:m_Width) = edge(:, 1:m_Width-1);
edge(:, 1) = 0;
edge(temp_e < -th_e) = 1;

% ����Ŀ��ͼ��tx_ides���ⲿ��������
R_ides = rx_ides_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
T_ides = rx_ides_rt(:, 4); % 3 x 1

%% ���ݲο�ͼ��rx_iref�����ͼ��rx_d������άͼ��任������Ŀ��ͼ��tx_ides
% ȷ���ϳɵ�Ŀ��ͼ��tx_ides�ı߽�
% tx_ides��4��������������Ϊ[0, 0, 1]'��[0, m_Height - 1, 1]'��[m_Width - 1, m_Height - 1, 1]'��[m_Width - 1, 0, 1]'������ͼ������ϵ��
% ���ΰ���ʱ������
IsV = [0  0              m_Width - 1    m_Width - 1
    0  m_Height - 1   m_Height - 1   0
    1  1              1              1];
IsXV = [IsV(1, :), IsV(1, 1)]; % x������β��ӹ���һȦ��ȷ����Ȧ��������ı߽�
IsYV = [IsV(2, :), IsV(2, 1)]; % y������β��ӹ���һȦ��ȷ����Ȧ��������ı߽磬��x�����Ӧ
clear IsV; % �ͷ��ڴ�ռ�

% ����Ŀ��ͼ���Ӧ�����������Cdes�ڲο�ͼ��rx_iref�е�ͶӰe
Ctmp = - inv(R_ides) * T_ides; % ����T = -RC������C��3 x 3
Cdes = [Ctmp; 1]; % ��Ϊ������꣬4 x 1
e = rx_pr * Cdes; % ͶӰ��������������ڲ�������������������ϵ��ѡ���޹أ�ֻҪ����ʽ���㼴��
e = e(1:3); % ��Ϊ��ά�������
e = Trl \ e; % ��x'o'y'�任��xoy
ez = e(3); % the homogeneous element, �����жϼ���ļ���
e = e / e(3); % ��λ�

% ����e�����꽫rx_iref����Ϊ���ɸ�Sheet
[Sheets, ANo] = SubdivideRefImg(m_Width, m_Height, e);

% ����Sheets�е����أ���������ͶӰ��I3
if ez < 0   % ������
    % ������
else % �����㣬�������򼫵�
    % ȷ��������˳��
    switch ANo
        case {'F'}
            % ����Sheet1
            Rect = Sheets{1};
            for i = Rect(2) : Rect(4)  % ����ɨ��
                for j = Rect(1) : Rect(3)
                    % �����[j; i; 1]
                    % ��ȡ���ͼ�ϵ�[j; i; 1]��ֵ
                    d = rx_d(i + 1, j + 1); % j + 1�У�i + 1�С�����RGB��������ͬ����ȡ����һ��, uint8
                    z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
                    % ��Ballet�����е����ͼ�����ֵ������ʱ�Ѿ���������������ϵ�������ӵ�ĸ������ص�zֵ���Ѿ��任������������ϵ��
                    %  ����Ҫ�ٿ��ǴӲο�ͼ���Ӧ������������������ϵ�任����������ϵ
                    [x, y] = projUVZtoXY(m_Height, rx_pr, double(j), double(i), z); % ����Ϊ0
                    [u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % ����Ϊ0
                    u_round = round(u_double); v_round = round(v_double);
                    
                    % �ж�[u, v]�Ƿ�����I1��
                    InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
                    if (InIs == 1)% �ڲŴ���
                        if tx_m(v_round+1, u_round+1)<d+th_d
                            tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v_round+1, u_round+1) = round(d);
%                             temp_m(v_round+1, u_round+1) = 1;
                        end
                        if edge(i+1, j+1) == 1 || u_round+1 >= m_Width || u_round <= 0
                            continue;
                        end
                        % ˮƽ����
                        v = v_round;
                        u = u_round+1;
                        if tx_m(v+1, u+1)+th_d<d
                            tx_ides(v+1, u+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u+1) = round(d);
                        end
                        if tx_m(v+1, u-1)+th_d<d
                            tx_ides(v+1, u-1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u-1) = round(d);
                        end
%                         tx_ides(v + 1, u + 1, :) =  rx_iref(i + 1, j + 1, :);
%                         tx_m(v + 1, u + 1) = round(d); % ���warped depth mapʱ����Ҫ����任��ֱ�ӿ������ɡ�
                    end
                end
            end
            
            % ����Sheet2
            Rect = Sheets{2};
            for i = Rect(4) : -1 : Rect(2)  % ����ɨ��
                for j = Rect(1) : Rect(3)
                    % �����[j; i; 1]
                    % ��ȡ���ͼ�ϵ�[j; i; 1]��ֵ
                    d = rx_d(i + 1, j + 1); % j + 1�У�i + 1�С�����RGB��������ͬ����ȡ����һ��
                    z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
                    % ��Ballet�����е����ͼ�����ֵ������ʱ�Ѿ���������������ϵ�������ӵ�ĸ������ص�zֵ���Ѿ��任������������ϵ��
                    %  ����Ҫ�ٿ��ǴӲο�ͼ���Ӧ������������������ϵ�任����������ϵ                    
                    [x, y] = projUVZtoXY(m_Height, rx_pr, double(j), double(i), z); % ����Ϊ0
                    [u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % ����Ϊ0
                    u_round = round(u_double); v_round = round(v_double);
                    
                    % �ж�[u, v]�Ƿ�����I1��
                    InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
                    if (InIs == 1)% �ڲŴ���
                        if tx_m(v_round+1, u_round+1)<d+th_d
                            tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v_round+1, u_round+1) = round(d);
%                             temp_m(v_round+1, u_round+1) = 1;
                        end
                        if edge(i+1, j+1) == 1 || u_round+1 >= m_Width || u_round <= 0
                            continue;
                        end
                        % ˮƽ����
                        v = v_round;
                        u = u_round+1;
                        if tx_m(v+1, u+1)+th_d<d
                            tx_ides(v+1, u+1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u+1) = round(d);
                        end
                        if tx_m(v+1, u-1)+th_d<d
                            tx_ides(v+1, u-1, :) = rx_iref(i + 1, j + 1, :);
                            tx_m(v+1, u-1) = round(d);
                        end
%                         tx_ides(v + 1, u + 1, :) =  rx_iref(i + 1, j + 1, :);
%                         tx_m(v + 1, u + 1) = round(d); % ���warped depth mapʱ����Ҫ����任��ֱ�ӿ������ɡ�
                    end
                end
            end
        otherwise
            disp('Unknow'); % ����һ���޸�����
    end
    %% show
%     figure(1);
%     imshow(tx_ides);
%     figure(2);
%     fig_m = tx_m;
%     fig_m(fig_m==-1)=0;
%     fig_m = uint8(fig_m);
%     imshow(fig_m);
%     figure(3)
%     imshow(rx_iref);
%     figure(4)
%     imshow(rx_d);
end;
