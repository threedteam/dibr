#python3 bin/gen_mask_dataset.py \
#$(pwd)/configs/data_gen/random_medium_512.yaml \
#Datasets/ballet_depth/val_source_512/ \
#Datasets/ballet_depth/val/random_medium_512/ \
#--ext jpg




#python3 bin/gen_mask_dataset.py \
#$(pwd)/configs/data_gen/random_medium_256.yaml \
#Datasets/ballet_bk_2w/val_source_256/ \
#Datasets/ballet_bk_2w/val/random_medium_256 \
#--ext jpg

python3 bin/gen_mask.py \
$(pwd)/configs/data_gen/randodm_medium_256.yaml \
Datasets/breakdancers_2w/val_source_256/ \
Datasets/breakdancers_2w/val_mask \
--ext jpg