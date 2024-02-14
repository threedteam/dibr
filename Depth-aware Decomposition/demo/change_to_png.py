""" turn jpg to png"""

import os
from PIL import Image

input_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/Dataset/Ballet/ballet_bk/ballet_original'
output_folder = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/Dataset/Ballet/ballet_bk/ballet_original_png'

for filename in os.listdir(input_folder):
    if filename.endswith('.jpg'):
        # 打开图像文件
        img = Image.open(os.path.join(input_folder, filename))
        # 生成新文件名
        new_filename = os.path.splitext(filename)[0] + '.png'
        # 保存图像文件
        img.save(os.path.join(output_folder, new_filename), 'png')
