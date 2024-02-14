
"show foreground and background according to the mask"


import cv2

# 读入彩色图片和mask图片
# img = cv2.imread('/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/origin_dibr/D_ballet/Is_ballet_des7.png')
img = cv2.imread('/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/improved_dibr/Ides_ballet/Is_ballet_des7.png')
mask = cv2.imread('/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/origin_dibr/instance_896_wo_dia/Is_ballet_des7_mask.png', 0)
# mask = cv2.imread('/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/improved_dibr/combined_mask/Is_ballet_des7_mask.png', 0)
# save_path = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/origin_dibr/show_instance/"
save_path = "/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/improved_dibr/show_instance/"

# 使用掩膜进行图像分割
result = cv2.bitwise_and(img, img, mask=mask)
bg_result = img - result

fg_path = save_path + "fg_show.png"
bg_path = save_path + "bk_show.png"

cv2.imwrite(fg_path, result)
cv2.imwrite(bg_path, bg_result )
# 显示结果
# cv2.imshow('Result', bk_result)
# cv2.waitKey(0)
# cv2.destroyAllWindows()