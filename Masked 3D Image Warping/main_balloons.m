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
% ȫ�ֱ���
% initialise parameters
calib_params_balloons; % read the calibration parameters of ��balloons�� sequence
data_path = 'G:\thesis_experiment_rxw\datasets\Balloons\';
mask_path = 'G:\thesis_experiment_rxw\datasets\Balloons\instance\';

save_path = 'G:\thesis_experiment_rxw\datasets\Balloons\improved_dibr';

%% 3D image warping for 300 frames
hole_pers = zeros(300,2);
warp_time = zeros(300,1);
for idx = 0 : 9
    t1=clock;
    %% input images and maps
     if (idx < 10)
        FileName = strcat(data_path, 'images\balloons5\color-cam5-f00', int2str(idx), '.png');
        IR = imread(FileName);
        
        % ��ȡIR��Ӧ�����ͼ
        FileName = strcat(data_path, 'depth\balloons5\depth-cam5-f00', int2str(idx), '.png');
        D = imread(FileName);
        
        % ��ȡ��Ӧ��instanceͼ
        FileName = strcat(mask_path, 'color-cam5-f00', int2str(idx), '_mask.png');
        instance_map = imread(FileName);
    else
        FileName = strcat(data_path, 'images\balloons5\color-cam5-f0', int2str(idx), '.png');
        IR = imread(FileName);
        
        % ��ȡIR��Ӧ�����ͼ
        FileName = strcat(data_path, 'depth\balloons5\depth-cam5-f0', int2str(idx), '.png');
        D = imread(FileName);
        
        FileName = strcat(mask_path, 'color-cam5-f0', int2str(idx), '_mask.png');
        instance_map = imread(FileName);
    end
%     % ��ȡ�����5�����ͼ��
%     FileName = strcat(data_path, 'images\balloons5\color-cam5-f', int2str(idx), '.png');
%     IR = imread(FileName);
%     
%     % ��ȡIR��Ӧ�����ͼ
%     FileName = strcat(data_path, 'depth\balloons5\depth-cam5-f', int2str(idx), '.png');
%     D = imread(FileName);
%     
%     % ��ȡ��Ӧ��instanceͼ
%     FileName = strcat(mask_path, 'color-cam5-f', int2str(idx), '_mask.png');
%     instance_map = imread(FileName);
    
    hi = size(IR, 1);
    wi = size(IR, 2);
    
    %% 3D image warping
    % M: generated non-hole matrix, double
    %       -1: current point is a hole-point
    %       [0, 255]: depth value of the current point
%     [Ides, M] = threed_image_warping_left(IR, D, MinZ, MaxZ, m1_ProjMatrix, m5_RT, m5_ProjMatrix);
      %�����ȴ���3����С���Խ��TD
%     if (idx == 0)
%        T_D = TD(IR, D, MinZ, MaxZ,  m1_ProjMatrix, m5_RT, m5_ProjMatrix);
%        fprintf('T_D  = %d', T_D );
%     end  
    
    
    [Ides, M, Ides_bk, M_bk, fg_map] = threed_image_warping_left_wmask(instance_map, IR, D, MinZ, MaxZ,  m1_ProjMatrix, m5_RT, m5_ProjMatrix);% Ides: generated destination image, uint8; M: generated non-hole matrix, double
    
    
    % ͳ��hole size
    hole_nums = M==-1;
    hole_nums = sum(sum(hole_nums));
    hole_per = hole_nums/(hi*wi);
    hole_pers(idx + 1,1) = hole_per;
    % for test
    % �����άͼ��任���
    %         FileName_Ides = strcat('Ides\Ides_TIW_', int2str(idx), '.bmp');
    %         imwrite(Ides, FileName_Ides);
    %         FileName_M = strcat('M\M_TIW_', int2str(idx), '.txt');
    %         save(FileName_M, 'M',  '-ASCII');
    %
%             figure(3);
%             imshow(Ides);
%             figure(4);
%             fig_m = M;
%             fig_m(fig_m==-1)=0;
%             fig_m = uint8(fig_m);
%             imshow(fig_m);
    
    %% non-hole matrix filtering
    % % for test;
    % FileName_Ides = strcat('Ides\Ides_TIW_', int2str(idx), '.bmp');
    % Ides = imread(FileName_Ides);
    % FileName_M = strcat('M\M_TIW_', int2str(idx), '.txt');
    % M = load(FileName_M);
    %
%     [Ides, M] = median_filtering(Ides, M, wi, hi);
    %
    % % save Ides and M���ڵ�ǰĿ¼��
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
    
    th_big_hole = 3; % threshold for big hole detection. if the number of hole-points in a hole is greater than th_big_hole, the hole is labeled as a ��big hole��
    sharp_th = 4; % threshold for sharp transition
    n_dilation = 3; % the number of points to be dilated
    rend_order = 0; % flag of the rending order of the reference image. The destination image positioned at camera 4 is rendered from camera 5 (camera 5 ? camera 4), therefore the destination image is right view.
    [Ides, M] = big_hole_dilation(Ides, M, th_big_hole, sharp_th, n_dilation, rend_order, wi, hi);
    [Ides_bk, M_bk] = big_hole_dilation(Ides_bk, M_bk, th_big_hole, sharp_th, n_dilation, rend_order, wi, hi);
    [fg_map, M] = big_hole_dilation(fg_map, M, th_big_hole, sharp_th, n_dilation, rend_order, wi, hi);
%     [Ides_map, M_map] = big_hole_dilation(Ides_map, M_map, th_big_hole, sharp_th, n_dilation, rend_order, wi, hi);
    % ͳ��hole size
    hole_nums = M==-1;
    hole_nums = sum(sum(hole_nums));
    hole_per = hole_nums/(hi*wi);
    hole_pers(idx+1,2) = hole_per;

    %% ����Ŀ��ͼ�������Ϣ
     D = M;
     
          %���������Ϣ���ɲ���
%      FileName_D = strcat('G:\thesis_experiment_rxw\datasets\Balloons\improved_dibr\D_balloons\Is_balloons_D', int2str(idx), '.txt');
%      save(FileName_D, 'D', '-ASCII');
     
     D(D==-1)=255;  %�����Ҫ���ͼ�пն�����Ϊ��ɫ��ֻ��Ҫ��ֵ��Ϊ0����
     D = uint8(D);
     
%      %����ն�ֵ��Ϊ255�����ͼ
%      FileName_dep = strcat('../datasets/ballet/improved_dibr/Depthmap_ballet/Is_ballet_depth_', int2str(idx), '.png');
%      imwrite(D, FileName_dep);
%     
     %% ����Ŀ��ͼ��ֻ��������Ϣ��Ŀ��ͼ
    %����Ŀ��ͼ��,�ն������Ǻ�ɫ��
%      FileName_Ides = strcat(save_path, 'black_hole/D_ballet/Is_ballet_des', int2str(idx), '.png');
%      imwrite(Ides, FileName_Ides);
     %����ֻ��������Ŀ��ͼ�񣬿ն������Ǻ�ɫ��
%      FileName_Ides_bk = strcat(save_path, 'black_hole/D_ballet_bk/Is_ballet_bk_des', int2str(idx), '.png');
%      imwrite(Ides_bk, FileName_Ides_bk);
     
    %% ��������cnn��ͼ�񡣺ڰ׷�ת:��ת��0����ǿ����ص㣬1����ն����ص�
    M(M ~= -1) = 1;
    M(M == -1) = 0;
    for i = 1 : hi
        ind = find(M(i,:) == 0);
        Ides(i, ind, :) = 255;
    end
    M =~ M;
    
    M_bk(M_bk ~= -1) = 1;
    M_bk(M_bk == -1) = 0;
    for i = 1 : hi
        ind = find(M_bk(i,:) == 0);
        Ides_bk(i, ind, :) = 255;
    end
    M_bk =~ M_bk;
    
    %��fg_map ���бղ���
    se = strel('disk', 15);
    fg_map = imclose(fg_map, se);
    t2=clock;
    warp_time(idx + 1,1)=etime(t2,t1);
    
%     %�����ɫ�ն���Ŀ��ͼ����mask
%     FileName_Ides = strcat(save_path, '\Ides_Balloons\Is_Balloons_des', int2str(idx), '.png');
%     imwrite(Ides, FileName_Ides);
%     FileName_M = strcat(save_path, '\M_Balloons\Is_Balloons_des', int2str(idx), '_mask.png');
%     imwrite(M, FileName_M);
% %     %�����ɫ�ն���Ŀ�걳��ͼ����mask
%     FileName_Ides = strcat(save_path, '\Ides_Balloons_bk\Is_Balloons_bk_des', int2str(idx), '.png');
%     imwrite(Ides_bk, FileName_Ides);
%     FileName_M_bk = strcat(save_path, '\M_Balloons_bk\Is_Balloons_bk_des', int2str(idx), '_mask.png');
%     imwrite(M_bk, FileName_M_bk);
%     %����ǰ������mask
%     FileName_fg_map = strcat(save_path, '\fg_instance\Is_Balloons_des', int2str(idx), '_mask.png');
%     imwrite(fg_map, FileName_fg_map);
    
    
end
% save('ballet_hole_pers.mat','hole_pers');
save('Balloons_warp_time.mat','warp_time');