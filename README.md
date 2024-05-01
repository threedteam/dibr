This repository contains code for three different models, each corresponding to a specific algorithm:

1、**Depth-aware Decomposition**

This folder contains code related to the Depth-aware Decomposition algorithm.

Main codes:
```
fg_inference_w_depth.py ： Uses depth information for foreground objects extraction. It takes the paths of color images and depth images as input and outputs the extracted foreground object mask.
	|    |
	|    ——object_decomposition: Selects foreground objects by taking the depth map, object mask, and a threshold to determine whether there is a sharp depth transition. The code includes a value representing the percentage of sharp depth transition, percent (default is 0.5), which can be used to select the foreground object mask.
	
	|    |
	|    ——run_on_image: Performs instance segmentation.
```

2、**Masked 3D Image Warping**
This folder contains code related to the Masked 3D Image Warping algorithm.

Main codes:
```
main.m: Masked 3D Image Warping Algorithm Source Code File

	|    ——threed_image_warping_wmask:3D image warping. It generates the target view from a reference view along with its corresponding depth map and foreground object mask for any viewpoint.
	|    |
	|    ——detect_holes.m: Hole detection. It detects holes in the target view.
	|    |
	|    ——big_hole_dilation.m: Dilating large holes. It dilates large holes based on the depth map.
	|    |
	|     T_D_calculate.m: Calculates the threshold for identifying foreground objects.
```

3、**Background Reconstruction**
This folder contains code related to the Background Reconstruction algorithm.

Main codes:

```
	|    ——predict.py: Generates the final hole-filled target view from the input target view with holes and its associated mask.
	|    |
	|    ——train.py: Used for training the generator with a batch size of 60. Additional training configurations can be found and set in the configuration document.
	|    |
	|    ——copy_final.py: Implements a layered merging algorithm to combine the predicted foreground and background layers.
	|    |
	|     gen_mask_dataset.py: Generates a masked dataset for training and evaluation purposes.
	|    |
	|    ——metrics.py: Contains metrics calculations.
	|    |
	|     find_bk.py: Prepares a dataset consisting of pure background images.
	
```


