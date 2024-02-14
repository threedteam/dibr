fileFolder=fullfile('G:\matlab-project\cnn_input_gen\M_breakdancers');
dirOutput=dir(fullfile(fileFolder,'*.png'));
fileNames={dirOutput.name}';

stride=64;
strideh=768/32;
stridew=1024/64;
% num=1;
% for i=1:length(fileNames)
%     for h=0:strideh-8
%         for w=0:stridew-4
%             mask = imread(['M_ballet\',fileNames{i}]);
%             crop = mask(h*32+1:h*32+256,w*stride+1:w*stride+256);
%             crop(crop==255)=1;
%             if sum(sum(crop)) > 10000
%                 crop(crop==1)=255;
%                 imwrite(crop,['cropedM_ballet\ballet_M',num2str(num),'.png']);
%                 num=num+1;
%             else
%                 continue
%             end
%         end
%     end
% end

%% crop margin mask
num=1;
for i=1:length(fileNames)
    for h=0:strideh-8
        mask = imread(['M_breakdancers\',fileNames{i}]);
        crop = mask(h*32+1:h*32+256,1:256);
        crop(crop==255)=1;
        crop(crop==1)=255;
        imwrite(crop,['margin_mask\breakdancers_M',num2str(num),'.png']);
        num=num+1;
    end
end