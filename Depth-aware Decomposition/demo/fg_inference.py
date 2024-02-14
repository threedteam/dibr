"""do instance segmentation and output mask"""

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
from scipy.ndimage import binary_dilation, binary_erosion
import torchvision.transforms.functional as F
import imageio.v2 as imageio

from detectron2.config import get_cfg
from detectron2.data.detection_utils import read_image
from detectron2.projects.deeplab import add_deeplab_config
from detectron2.utils.logger import setup_logger

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
                path = os.path.join(args.input, filename)
                # use PIL, to be consistent with evaluation
                img = read_image(path, format="BGR")
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



# /media/zrway/7f6f1ac1-24aa-4dfb-ab0a-ed8c3287463d/rxw/Dataset/Ballet/MSR3DVideo-Ballet/cam5-depth