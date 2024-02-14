from PIL import Image
import os
import numpy as np
if __name__ == '__main__':
    img_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/kendo_bk_2w/Original'
    crop_img_save_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/kendo_bk_2w/Croped_temp/'
    img_flist_path = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/Datasets/kendo_bk_2w/kendo_crop.flist'
    mask_dir = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/Dataset/kendo/instance/'
    if not os.path.exists(crop_img_save_folder):
        os.makedirs(crop_img_save_folder)
    stride = 64
    # more_stride = 16
    more_stride = 64
    strideh = 768 // 32
    stridew = 1024 // 64
    size = 256
    num = 1
    fo1 = open(img_flist_path, 'w')

    #根据背景块查找周边的背景
    def is_valid_move(row, col, rows, cols):
        return 0 <= row < rows and 0 <= col < cols


    def more_details(h, w, maxh, maxw):
        global num
        for nowh in range(1):
            for noww in range(1):
                # if num > 22000:
                #     break
                if np.sum(np.array(mask.crop(((w + noww) * stridew, (h + nowh) * strideh, (w + noww) * stridew + size,
                                              (h + nowh) * strideh + size)))) == 0 \
                        and (w + noww) < maxw and (h + nowh) < maxh:
                    cropI = img.crop(((w + noww) * stridew, (h + nowh) * strideh, (w + noww) * stridew + size,
                                      (h + nowh) * strideh + size))
                    img_save_path = os.path.join(crop_img_save_folder, str(num) + '.jpg')
                    fo1.write(str(num) + '.jpg' + '\n')
                    cropI.save(img_save_path)
                    num += 1

    def find_more(mask_info,h,w,maxh,maxw):
        if not is_valid_move(h, w, maxh, maxw):
            return
        if mask_info[h][w] == 0:
            more_details(h,w,maxh,maxw)
            return
        mask_info[h][w] = 0
        directions = [(-2, 0), (2, 0), (0, -2), (0, 2)]
        for dh, dw in directions:
            new_h, new_w = h + dh, w + dw
            find_more(mask_info, new_h, new_w,maxh,maxw)

    #查找边缘的背景
    def findCounterBk(mask, img):
        def process_crop(r, c, r_offset, c_offset):
            global num
            if num > 22000:  # 当num达到20000时跳出循环
                return
            if (0 <= r < mask.size[0] and 0 <= c < mask.size[1] and 0 <= r + r_offset < mask.size[
                0] and 0 <= c + c_offset < mask.size[1]):
                r, r1 = (r, r + r_offset) if r < r + r_offset else (r + r_offset, r)
                c, c1 = (c, c + c_offset) if c < c + c_offset else (c + c_offset, c)
                if np.sum(np.array(mask.crop((r, c, r1, c1)))) == 0:
                    cropI = img.crop((r, c, r1, c1))
                    img_save_path = os.path.join(crop_img_save_folder, str(num) + '.jpg')
                    fo1.write(str(num) + '.jpg' + '\n')
                    cropI.save(img_save_path)
                    num += 1

        shifted_mask = np.roll(mask, shift=1, axis=1)
        edges = np.logical_xor(shifted_mask, mask)
        edge_indices = np.argwhere(edges > 0)

        for r, c in edge_indices[::2]:
            process_crop(r + 2, c + 2, 256, 256)
            process_crop(r - 2, c + 2, -256, 256)
            process_crop(r - 2, c - 2, -256, -256)
            process_crop(r + 2, c - 2, 256, -256)

    #均匀切割保存背景
    def generate_cropped_images(img, mask):
        stridew = 32
        strideh = 16
        size = 256  # 可自己控制图片的尺寸
        global num
        for h in range(img.size[1] // strideh - size // strideh):
            for w in range(img.size[0] // stridew - size // stridew):
                cropI = img.crop((w * stridew, h * strideh, w * stridew + size, h * strideh + size))
                mask_crop = mask.crop((w * stridew, h * strideh, w * stridew + size, h * strideh + size))

                if np.sum(np.array(mask_crop)) == 0:
                    img_save_path = os.path.join(crop_img_save_folder, str(num) + '.jpg')
                    fo1.write(str(num) + '.jpg' + '\n')
                    cropI.save(img_save_path)
                    num += 1
                else:
                    # process as per your requirement
                    pass

    for filename in os.listdir(img_folder):
        if filename.endswith(".jpg") or filename.endswith(".png"):
            mask_path = mask_dir + os.path.splitext(filename)[0] + "_mask.png"
            print(f"Processing image {filename}")
            img = Image.open(os.path.join(img_folder, filename))
            mask = Image.open(mask_path).convert('1')
            mask_info = []

            if num > 22000:  # break the outer loop as well
                break

            generate_cropped_images(img, mask)

            findCounterBk(mask, img)

            for h in range(strideh - 8):
                temp = []
                for w in range(stridew - 4):
                    if np.sum(np.array(mask.crop((w * stride, h * 32, w * stride + 256, h * 32 + 256)))) == 0:
                        temp.append(0)  # this area don't have foreground
                    else:
                        temp.append(1)
                mask_info.append(temp)

            for h in range(strideh - 8):
                for w in range(stridew - 4):
                    # crop image
                    if num > 22000:  # break the loop when num reaches 20000
                        break
                    if mask_info[h][w] == 1:
                        find_more(mask_info, h, w, strideh - 8, stridew - 4)
                    if np.sum(np.array(mask.crop((w * stride, h * 32, w * stride + 256, h * 32 + 256)))) != 0:
                        continue
                    cropI = img.crop((w * stride, h * 32, w * stride + 256, h * 32 + 256))
                    img_save_path = os.path.join(crop_img_save_folder, str(num) + '.jpg')
                    fo1.write(str(num) + '.jpg' + '\n')
                    cropI.save(img_save_path)
                    num += 1

            print(filename, " crop finished")
            if num > 22000:  # break the main loop when num reaches 20000
                break
    fo1.close()

