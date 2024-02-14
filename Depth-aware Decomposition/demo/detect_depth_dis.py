import torch
import numpy as np
from scipy.ndimage import binary_dilation, binary_erosion
import torchvision.transforms.functional as F
import imageio.v2 as imageio

# 读入深度图和 mask 图
depth_image = imageio.imread("/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/Dataset/Ballet/MSR3DVideo-Ballet/cam5-depth/depth-cam5-f007.png")
mask_image = imageio.imread("/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/ballet/original_instance/color-cam5-f007_mask.png")

# 将深度图和 mask 图转换为 tensor
depth = torch.from_numpy(depth_image.transpose((2, 0, 1)))[0].to("cuda:0")
mask = torch.from_numpy(mask_image.transpose((2, 0, 1)))[0].to("cuda:0")

def detect_depth_discontinuity(depth: torch.Tensor, mask: torch.Tensor):
    # 提取物体边缘
    threshold = 5

    # get slightly larger edge border region
    object_depth = torch.masked_select(depth, mask.bool())
    object_dilated = binary_dilation(mask.cpu().numpy(), iterations=1)
    out_region = np.logical_xor(object_dilated, mask.cpu().numpy())

    #get slightly smaller edge border region
    object_dilated = binary_erosion(mask.cpu().numpy(), iterations=1)
    in_region = np.logical_xor(object_dilated, mask.cpu().numpy())

    out_depth = torch.masked_select(depth, torch.from_numpy(out_region).bool().to("cuda:0")).cpu().numpy()
    in_depth = torch.masked_select(depth, torch.from_numpy(in_region).bool().to("cuda:0")).cpu().numpy()

    return np.abs(out_depth - in_depth) > threshold

# 使用函数判断是否存在深度跃变
threshold = 0.1 # 设定阈值
mean_depth = detect_depth_discontinuity(depth, mask)
if torch.abs(mean_depth - detect_depth_discontinuity(depth, mask)) > threshold:
    print("存在深度跃变")
else:
    print("不存在深度跃变")