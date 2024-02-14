import os
import numpy as np


# file_path = './dataset/croped_ballet'
# output_train_path = './dataset/ballet_train.flist'
# output_val_path = './dataset/ballet_val.flist'

file_path = '/home/user26/lama-main/my_dataset/ballet'
output_train_path = '/media/user26/数据/zyt/thesis_experiment/datasets/navigation/train_navigation_M_crop.flist'
output_val_path = '/media/user26/数据/zyt/thesis_experiment/datasets/navigation/train_navigation_M_crop.flist'

ext = {'.jpg', '.png'}

images = []
for root, dirs, files in os.walk(file_path):
    print('loading ' + root)
    for file in files:
        if os.path.splitext(file)[1] in ext:
            images.append(os.path.join(root, file))

k = int(len(images)*0.7)
train = images[0:k]
val = images[k:]

np.savetxt(output_train_path, train, fmt='%s')
np.savetxt(output_val_path, val, fmt='%s')