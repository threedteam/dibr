import os
import re


folder_path = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/lama-main/output/kendo/kendo_fg_lama" # 将路径替换为实际文件夹的路径
save_folder = folder_path

if not os.path.exists(save_folder):
    os.mkdir(save_folder)

# 遍历完整彩色图片文件夹
for filename in os.listdir(folder_path):
    if filename.endswith('.jpg') or filename.endswith('.png'):


        # 构建保存路径
        original_name = "color-cam1-f"
        # original_name = "color-cam4-f"
        num = re.search(r'\d+', filename).group().zfill(3)
        save_filename = original_name + num + ".jpg"
        save_path = os.path.join(save_folder, save_filename)
        os.rename(os.path.join(folder_path, filename), save_path)
print("finished!")