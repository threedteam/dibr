clc
clear
% filter_time = zeros(300,1);
hole_pers = zeros(100,1);
for idx = 0:99
    FileName = strcat('../datasets/breakdancers/improved_dibr/Ides_breakdancers/Is_breakdancers_des', int2str(idx), '.png');
    img = imread(FileName);
    FileName = strcat('../datasets/breakdancers/improved_dibr/M_breakdancers/Is_breakdancers_M', int2str(idx), '.png');
    M = imread(FileName);
    hi = size(img, 1);
    wi = size(img, 2);
    % 统计时间
%     t1=clock;
    filtered = Filter(img);
%     t2=clock;
%     filter_time(idx,1)=etime(t2,t1);
    
    % 统计hole size
    M = uint8(M);
    M(M==1) = 255;
    M = cat(3,M,M,M);
    M = Filter(M);
    M = M(:,:,1);
    hole_nums = M==255;
    hole_nums = sum(sum(hole_nums));
    hole_per = hole_nums/(hi*wi);
    hole_pers(idx+1,1) = hole_per;
    
    % 保存
    M = logical(M);
    FileName = strcat('../datasets/breakdancers/improved_dibr/Filter_breakdancers/Is_breakdancers_M', int2str(idx), '.png');
    imwrite(M, FileName);
    FileName = strcat('../datasets/breakdancers/improved_dibr/Filter_breakdancers/Is_breakdancers_des', int2str(idx), '.png');
    imwrite(filtered, FileName);
end
% save('breakdancers_filter_time1.mat','filter_time');
save('breakdancers_hole_pers1.mat','hole_pers');