"""add original mask to instance segmentation"""


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
        "--mask",
        help="A folder containing input mask images",
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
                img_path = os.path.join(args.input, filename)
                # original_mask  =
                # use PIL, to be consistent with evaluation
                img = read_image(img_path, format="BGR")

                original_mask_path = os.path.join(args.mask, filename.replace("_des", "_M"))
                original_mask = read_image(original_mask_path, format="L")
                # original_mask = torch.from_numpy(np.array(original_mask)).to("cuda:0").permute(2,0,1)
                # original_mask = torch.clamp(original_mask,0,1)

                start_time = time.time()
                predictions, visualized_output = demo.run_on_image(img, args.task)
                logger.info(
                    "{}: {} in {:.2f}s".format(
                        img_path,
                        "detected {} instances".format(len(predictions["instances"]))
                        if "instances" in predictions
                        else "finished",
                        time.time() - start_time,
                    )
                )
                mask = predictions['instances'].get_fields()['pred_masks']
                # mask_ins = torch.cat((mask, original_mask), dim=0)
                # mask_ins = torch.amax(mask_ins, dim=0)
                mask_ins = torch.amax(mask, dim=0)
                # save mask_ins as an image
                mask_ins = mask_ins.cpu().numpy().astype(np.uint8) * 255
                mask_ins = cv2.cvtColor(mask_ins, cv2.COLOR_GRAY2BGR)

                #dilation
                kernel = np.ones((3, 3), np.uint8)
                mask_ins = cv2.dilate(mask_ins, kernel, iterations=2)

                combined_mask = mask_ins[:,:,0] + original_mask[:,:,0]
                combined_mask = cv2.cvtColor(combined_mask, cv2.COLOR_GRAY2BGR)

                mask_filename = os.path.splitext(filename)[0] + "_mask.png"
                # mask_filename = os.path.splitext(filename)[0] + ".png"
                mask_path = os.path.join(args.output, mask_filename) if args.output else mask_filename
                cv2.imwrite(mask_path, combined_mask )


else:
        raise ValueError("No Input Given")