import os

# 获取文件夹中所有图片的文件名
img_folder = '/home/user26/lama-main/my_dataset/visual_test_source'
save_flist_folder = '/home/user26/lama-main/fetch_data'

img_names = os.listdir(img_folder)
img_names = [name for name in img_names if name.endswith('.jpg')]

# 重命名图片文件名
for i, name in enumerate(img_names):
    new_name = f'{i+19201}.jpg'
    os.rename(os.path.join(img_folder, name), os.path.join(img_folder, new_name))

# 生成flist文件
with open(os.path.join(save_flist_folder, 'ballet_test.flist'), 'w') as f:
    for name in img_names:
        f.write(name + '\n')