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
%     Corresponding author：Ran Liu
%     Address: College of Computer Science, Chongqing University, 400044, Chongqing, P.R.China
%     Phone: +86 136 5835 8706
%     Fax: +86 23 65111874
%     Email: ran.liu_cqu@qq.com
%
%     Filename         : main.m
%     Description      :
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-10-28  |   Donghua Cao                 |   Original
%         1.01     |  2014-10-28  |   Ran Liu                     |   The code style has been changed
%         1.02     |  2018-09-15  |   Ran Liu                     |   Modules of median filtering and big hole dilation have been added
%         1.03     |  2019-12-11  |   ZYT                         |   Module of threed_image_warping has been modified for improved DIBR method
%   ------------------------------------------------------------------------
% =========================================================================================================
clc
clear
% 全局变量
% initialise parameters
calib_params_champagne; % read the calibration parameters of “champagne” sequence
data_path = 'D:\thesis_experiment\datasets\Champagne_tower\';

%% 3D image warping for 100 frames
for idx = 1 : 300
    %% input images and maps
    % 读取摄像机3捕获的图像
    FileName = strcat(data_path, 'images\champagne37\color-cam37-f', int2str(idx), '.png');
    IR = imread(FileName);
    
    % 读取IR对应的深度图
    FileName = strcat(data_path, 'depth\champagne37\depth-cam37-f', int2str(idx), '.png');
    D = imread(FileName);
    
    hi = size(IR, 1);
    wi = size(IR, 2);
    
    %% 3D image warping
    % M: generated non-hole matrix, double
    %       -1: current point is a hole-point
    %       [0, 255]: depth value of the current point
    [Ides, M] = threed_image_warping_old(IR, D, MinZ, MaxZ, m41_ProjMatrix, m37_RT, m37_ProjMatrix); % Ides: generated destination image, uint8; M: generated non-hole matrix, double
    % for test
    % 输出三维图像变换结果
    %         FileName_Ides = strcat('Ides\Ides_TIW_', int2str(idx), '.bmp');
    %         imwrite(Ides, FileName_Ides);
    %         FileName_M = strcat('M\M_TIW_', int2str(idx), '.txt');
    %         save(FileName_M, 'M',  '-ASCII');
    %
            figure(3);
            imshow(Ides);
            figure(4);
            fig_m = M;
            fig_m(fig_m==-1)=255;
            fig_m = uint8(fig_m);
            imshow(fig_m);
    
    %% non-hole matrix filtering
    % % for test;
    % FileName_Ides = strcat('Ides\Ides_TIW_', int2str(idx), '.bmp');
    % Ides = imread(FileName_Ides);
    % FileName_M = strcat('M\M_TIW_', int2str(idx), '.txt');
    % M = load(FileName_M);
    %
%     [Ides, M] = median_filtering(Ides, M, wi, hi);
    %
    % % save Ides and M，在当前目录下
    % FileName_Ides = strcat('Ides\Ides_MF_', int2str(idx), '.bmp');
    % imwrite(Ides, FileName_Ides);
    % FileName_M = strcat('M\M_MF_', int2str(idx), '.txt');
    % save(FileName_M, 'M',  '-ASCII');
    
    %        for test
    %         figure(3);
    %         imshow(Ides);
    %         figure(4);
    %         imshow(M);
    
    %%  big_hole_dilation
    %     for test;
%     FileName_Ides = strcat('Ides\Ides_TIW_', int2str(idx), '.bmp');
%     Ides = imread(FileName_Ides);
%     FileName_M = strcat('M\M_TIW_', int2str(idx), '.txt');
%     M = load(FileName_M);
%     figure(1);
%     imshow(Ides);
    
%     a = Ides; % for test
    
%     figure(2);
%     imshow(M);
    
    th_big_hole = 3; % threshold for big hole detection. if the number of hole-points in a hole is greater than th_big_hole, the hole is labeled as a “big hole”
    sharp_th = 4; % threshold for sharp transition
    n_dilation = 3; % the number of points to be dilated
    rend_order = 0; % flag of the rending order of the reference image. The destination image positioned at camera 4 is rendered from camera 5 (camera 5 ? camera 4), therefore the destination image is right view.
    [Ides, M] = big_hole_dilation(Ides, M, th_big_hole, sharp_th, n_dilation, rend_order, wi, hi);

    %% 黑白翻转:翻转后，0代表非空像素点，1代表空洞像素点
    M(M ~= -1) = 1;
    M(M == -1) = 0;
    for i = 1 : hi
        ind = find(M(i,:) == 0);
        Ides(i, ind, :) = 255;
    end
        M =~ M;
    %% 保存深度图，空洞像素为255
%     M(M == -1) = 255;
%     M=uint8(M);
    %% 保存big hole dilation后的结果
    FileName_Ides = strcat('../datasets/breakdancers/improved_dibr/Ides_breakdancers/Is_breakdancers_des', int2str(idx), '.png');
    imwrite(Ides, FileName_Ides);
    FileName_M = strcat('../datasets/breakdancers/improved_dibr/M_breakdancers/Is_breakdancers_M', int2str(idx), '.png');
    imwrite(M, FileName_M);    
end