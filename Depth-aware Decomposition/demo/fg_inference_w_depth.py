"""do instance segmentation with depth information help and output mask"""

import argparse
import multiprocessing as mp
import os
import torch
import random
# fmt: off
import sys
sys.path.insert(1, os.path.join(sys.path[0], '..'))
# fmt: on

import time
import cv2
import numpy as np
import tqdm
from scipy.ndimage import binary_dilation, binary_erosion, label
import torch.nn.functional as F
import imageio.v2 as imageio

from detectron2.config import get_cfg
from detectron2.data.detection_utils import read_image
from detectron2.projects.deeplab import add_deeplab_config
from detectron2.utils.logger import setup_logger
import time

from skimage import filters, feature, measure

from oneformer import (
    add_oneformer_config,
    add_common_config,
    add_swin_config,
    add_dinat_config,
    add_convnext_config,
)
from predictor import VisualizationDemo

# constants
WINDOW_NAME = "OneFormer Demo"

def setup_cfg(args):
    # load config from file and command-line arguments
    cfg = get_cfg()
    add_deeplab_config(cfg)
    add_common_config(cfg)
    add_swin_config(cfg)
    add_dinat_config(cfg)
    add_convnext_config(cfg)
    add_oneformer_config(cfg)
    cfg.merge_from_file(args.config_file)
    cfg.merge_from_list(args.opts)
    cfg.freeze()
    return cfg



def object_decomposition(depth: torch.Tensor, mask: torch.Tensor, threshold: float):
    labeled_mask, num_objects = label(mask.cpu().numpy())
    for j in range(1, num_objects + 1):
        object_mask = torch.from_numpy(labeled_mask == j).float()

        # Extract the edges of the mask
        shifted_mask = torch.roll(object_mask, shifts=1, dims=1)
        edges1 = torch.abs(shifted_mask - object_mask)

        shifted_mask1 = torch.roll(object_mask, shifts=1, dims=0)
        edges0 = torch.abs(shifted_mask1 - object_mask)
        edges = edges0 + edges1

        # Get the indices of the edge pixels
        edge_indices = torch.nonzero(edges > 0)
        count = 0

        if edge_indices.shape[0] == 0:
            continue

        for i in range(edge_indices.shape[0]):
            # Calculate the depth differences for the four neighboring pixels of each edge pixel
            rd = 2  # set the round neighborhood range
            r, c = edge_indices[i][0], edge_indices[i][1]
            neighborhood = depth[max(0, r - rd):min(depth.shape[0], r + rd + 1),
                           max(0, c - rd):min(depth.shape[1], c + rd + 1)]
            td = torch.max(neighborhood) - torch.min(neighborhood)  # depth change around the counter
            if (td > threshold):
                count += 1

        # start_time = time.time()
        # block1_time = time.time() - start_time
        # print("代码块1执行时间：", block1_time)


        # If more than 50% of the depth differences exceed the threshold, set all non-zero regions in the mask to 1
        # Otherwise, set all values in the mask to 0
        percent = count / edge_indices.shape[0]
        print(percent)
        if percent > 0.5:
            mask[object_mask  > 0] = 1
        else:
            mask[object_mask  > 0] = 0

    return mask




def get_parser():
    parser = argparse.ArgumentParser(description="oneformer demo for builtin configs")
    parser.add_argument(
        "--config-file",
        default="../configs/ade20k/swin/oneformer_swin_large_IN21k_384_bs16_160k.yaml",
        metavar="FILE",
        help="path to config file",
    )
    parser.add_argument("--task", help="Task type")
    parser.add_argument(
        "--input",
        help="A folder containing input images",
    )

    parser.add_argument(
        "--depth",
        help="A folder containing input depth images",
    )

    parser.add_argument(
        "--output",
        help="A file or directory to save output visualizations. "
        "If not given, will show output in an OpenCV window.",
    )

    parser.add_argument(
        "--confidence-threshold",
        type=float,
        default=0.5,
        help="Minimum score for instance predictions to be shown",
    )
    parser.add_argument(
        "--opts",
        help="Modify config options using the command-line 'KEY VALUE' pairs",
        default=[],
        nargs=argparse.REMAINDER,
    )
    return parser

if __name__ == "__main__":

    seed = 0
    firtst_time = time.time()
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False

    mp.set_start_method("spawn", force=True)
    args = get_parser().parse_args()
    setup_logger(name="fvcore")
    logger = setup_logger()
    logger.info("Arguments: " + str(args))

    cfg = setup_cfg(args)

    demo = VisualizationDemo(cfg)

    os.makedirs(args.output, exist_ok=True)

    if args.input:
        for filename in tqdm.tqdm(os.listdir(args.input), disable=not args.output):
            if filename.endswith(".jpg") or filename.endswith(".png"):
                #for test
                # filename = 'color-cam5-f001.jpg'
                # filename = 'color-cam5-f001.png'

                path = os.path.join(args.input, filename)
                # use PIL, to be consistent with evaluation

                img = read_image(path, format="BGR")

                depth_path = os.path.join(args.depth, filename.replace("color", "depth").split(".")[0] + ".png")
                depth_image = read_image(depth_path, format="L")  # (768, 1024, 1)
                d1 = depth_image[:, :, 0]
                depth_image = torch.from_numpy(depth_image.transpose((2, 0, 1)))[0].to("cuda:0")  # torch.Size([1, 768, 1024])

                start_time = time.time()
                predictions, visualized_output = demo.run_on_image(img, args.task)
                logger.info(
                    "{}: {} in {:.2f}s".format(
                        path,
                        "detected {} instances".format(len(predictions["instances"]))
                        if "instances" in predictions
                        else "finished",
                        time.time() - start_time,
                    )
                )
                mask = predictions['instances'].get_fields()['pred_masks']
                # 提取物体边缘
                # threshold = calculate_threshold(depth_image)
                threshold = 3

                for i in range(mask.shape[0]):
                    # mask[i] =  detect_area_depth_discontinuity(depth_image, mask[i], threshold)
                    mask[i] =  object_decomposition(depth_image, mask[i], threshold)
                # mask = [mask[item] for item in range(len(mask)) if detect_depth_discontinuity(depth_image, mask[item],threshold)]
                # mask = torch.stack(mask)   #turn list to tensor

                # # create an empty list to store filtered mask slices
                # filtered_mask = []
                #
                # # iterate through each slice in mask
                # for item in range(len(mask)):
                #     # check if detect_depth_discontinuity output is True
                #     if detect_depth_discontinuity(depth_image, mask[item]):
                #         # if True, append this slice to filtered_mask list
                #         filtered_mask.append(mask[item])

                mask_ins = torch.amax(mask, dim=0)
                # save mask_ins as an image
                mask_ins = mask_ins.cpu().numpy().astype(np.uint8) * 255
                mask_ins = cv2.cvtColor(mask_ins, cv2.COLOR_GRAY2BGR)

                #dilation
                kernel = np.ones((3, 3), np.uint8)
                # mask_ins = cv2.dilate(mask_ins, kernel, iterations=2)

                mask_filename = os.path.splitext(filename)[0] + "_mask.png"
                # mask_filename = os.path.splitext(filename)[0] + ".png"
                mask_path = os.path.join(args.output, mask_filename) if args.output else mask_filename
                cv2.imwrite(mask_path, mask_ins)
    else:
        raise ValueError("No Input Given")

    end_time = time.time()
    print(firtst_time)
    print(end_time)
    execution_time = end_time - firtst_time
    file_path = '/media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/OneFormer-main/datasets/kendo/execution_time.txt'
    with open(file_path, 'w') as file:
        file.write(str(execution_time))
    print("Total execution time:", execution_time, "seconds")



# /media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/Dataset/Ballet/MSR3DVideo-Ballet/cam5-depth