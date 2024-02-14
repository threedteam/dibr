"""
source_folder: 填充后的背景图  Is_ballet_des0.png...
target_folder：需要填充的带空洞目标图及其对应的mask  Is_ballet_des0.png  Is_ballet_des0_mask.png。。
save_folder： 复制背景图到目标图像后，保存的文件夹路径
"""

from PIL import Image
import os
import re
import time

start_time = time.time()

# 完整彩色图片所在文件夹路径-背景
# source_folder_bg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/ballet/ballet_bg"
# # 完整彩色图片所在文件夹路径-前景
# source_folder_fg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/ballet/ballet_fg"
# # 带空洞彩色图片和对应mask所在文件夹路径
# target_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/LaMa_test_images/ballet/ballet_fg"
# save_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/ballet/final"

# 完整彩色图片所在文件夹路径-背景
# source_folder_bg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/breakdancers/breakdancers_bg"
# # 完整彩色图片所在文件夹路径-前景
# source_folder_fg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/breakdancers/breakdancers_fg"
# # 带空洞彩色图片和对应mask所在文件夹路径
# target_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/LaMa_test_images/breakdanceres/breakdancers_fg"
# save_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/breakdancers/final"

# 完整彩色图片所在文件夹路径-背景
source_folder_bg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/Balloons/Balloons_bg"
# 完整彩色图片所在文件夹路径-前景
source_folder_fg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/Balloons/Balloons_fg"
# 带空洞彩色图片和对应mask所在文件夹路径
target_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/LaMa_test_images/Balloons/Balloons_fg"
save_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/Balloons/final"


# # # 完整彩色图片所在文件夹路径-背景
# source_folder_bg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/kendo/kendo_bg"
# # 完整彩色图片所在文件夹路径-前景
# source_folder_fg = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/kendo/kendo_fg"
# # 带空洞彩色图片和对应mask所在文件夹路径
# target_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/LaMa_test_images/kendo/kendo_fg"
# save_folder = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/kendo/final"

if not os.path.exists(save_folder):
    os.mkdir(save_folder)

# 遍历完整彩色图片文件夹
for filename in os.listdir(source_folder_bg):
    if filename.endswith('.jpg') or filename.endswith('.png'):
        # 读取完整彩色图片
        source_image = Image.open(os.path.join(source_folder_bg, filename))

        # 获取对应的带空洞彩色图片和mask文件名
        # target_filename = filename.replace("Is_ballet_bk_","Is_ballet_")
        target_filename = filename.replace("_bk_", "_")


        target_image_path = os.path.join(target_folder, target_filename)
        source_image_fg = Image.open(os.path.join(source_folder_fg, target_filename))


        mask_filename = target_filename.replace('.jpg', '_mask.jpg').replace('.png', '_mask.png')
        mask_image_path = os.path.join(target_folder, target_filename.replace('.jpg', '_mask.jpg').replace('.png', '_mask.png'))

        fg_mask_path =os.path.join(source_folder_fg, target_filename.replace('.jpg', '_mask.jpg').replace('.png', '_mask.png'))

        # 检查带空洞彩色图片和mask是否存在
        if os.path.exists(target_image_path) and os.path.exists(mask_image_path):
            # 读取带空洞彩色图片和mask
            target_image = Image.open(target_image_path)
            mask_image = Image.open(mask_image_path).convert('L')  # 转为灰度图像

            fg_mask_image = Image.open(fg_mask_path).convert('L')

            # 获取图片的宽度和高度
            width, height = target_image.size

            # 遍历每个像素点
            for x in range(width):
                for y in range(height):
                    # 判断mask中是否为255（空洞）
                    if mask_image.getpixel((x, y)) == 255 and fg_mask_image.getpixel((x, y)) != 255:
                        # 获取对应位置的像素值，并替换到带空洞彩色图片中
                        source_pixel = source_image.getpixel((x, y))
                        target_image.putpixel((x, y), source_pixel)
                    elif mask_image.getpixel((x, y)) == 255 and fg_mask_image.getpixel((x, y)) == 255:
                        source_pixel = source_image_fg.getpixel((x, y))
                        target_image.putpixel((x, y), source_pixel)


            # 构建保存路径
            # original_name = "color-cam1-f"
            original_name = "color-cam4-f"
            num = re.search(r'\d+', filename).group().zfill(3)
            save_filename =  original_name + num + ".jpg"
            save_path = os.path.join(save_folder, save_filename)

            # 保存处理后的带空洞彩色图片
            target_image.save(save_path)
            print(f"Processed: {filename}")
        else:
            print(f"Missing file: {filename}")

end_time = time.time()
execution_time = end_time - start_time
file_path = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/time_record/execution_time.txt'
with open(file_path, 'a') as file:
    file.write(str(execution_time))
print("Total execution time:", execution_time, "seconds")