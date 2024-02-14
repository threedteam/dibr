
#this code crops images to size 512 * 512 or 256*256

import cv2
from PIL import Image
import os

if __name__ == '__main__':
    # img_folder = '/data/rxw/lama-main/Datasets/breakdancers_depth/Original/'
    # crop_img_save_folder = '/data/rxw/lama-main/Datasets/breakdancers_depth/Croped_temp'
    # img_flist_path = '/data/rxw/lama-main/Datasets/breakdancers_depth/breakdancers_crop.flist'

    # img_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/breakdancers_test/breakdancers_original'
    # crop_img_save_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/breakdancers_test/breakdancers_crop'
    # img_flist_path = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/breakdancers_test/breakdancers_crop.flist'

    img_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/breakdancers_2w/Original'
    crop_img_save_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/breakdancers_2w/Croped_temp'
    img_flist_path = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/breakdancers_2w/breakdancers_crop.flist'

    if not os.path.exists(crop_img_save_folder):
        os.makedirs(crop_img_save_folder)


    stridew = 64
    strideh = 32
    size = 256     #可自己控制图片的尺寸

    # strideh = 768 // 64
    # stridew = 1024 // 128
    num = 1

    fo1 = open(img_flist_path, 'w')
    #generate 19200 pictures
    for filename in os.listdir(img_folder):
        if filename.endswith(".jpg") or filename.endswith(".png"):

            img = Image.open(os.path.join(img_folder, filename))

            for h in range(img.size[1] // strideh  - size //strideh):
                for w in range(img.size[0] // stridew - size //stridew):
                    # crop image
                    cropI = img.crop((w * stridew, h * strideh, w * stridew + size, h * strideh + size))
                    img_save_path = os.path.join(crop_img_save_folder, str(num) + '.jpg')

                    fo1.write(str(num) + '.jpg' + '\n')
                    cropI.save(img_save_path)
                    num += 1
            # 添加额外的裁剪
            for i in range(4):  # 每张图片再多裁剪出28张小的图片
                for j in range(7):
                    cropI = img.crop((j * 128 + 1, i * 128, j * 128 + 1 + size,
                                      i * 128 + size))
                    img_save_path = os.path.join(crop_img_save_folder, str(num) + '.jpg')
                    fo1.write(str(num) + '.jpg' + '\n')
                    cropI.save(img_save_path)
                    num += 1
            print(filename, " crop finished")
    #generate rest pictures

    fo1.close()

    
    
    

