

## Split: split train -> train & val

cat Datasets/ballet_bk_2w/ballet_crop.flist | shuf > Datasets/ballet_bk_2w/temp_train_shuffled.flist
cat Datasets/ballet_bk_2w/temp_train_shuffled.flist | head -n 2000 > Datasets/ballet_bk_2w/val_shuffled.flist
cat Datasets/ballet_bk_2w/temp_train_shuffled.flist | tail -n +2001 > Datasets/ballet_bk_2w/train_shuffled.flist
#cat fetch_data/ballet_bk_2w_test.flist | shuf > my_dataset/visual_test_shuffled.flist
#
#
mkdir Datasets/ballet_bk_2w/train/
mkdir Datasets/ballet_bk_2w/val_source_256/
#
#
cat Datasets/ballet_bk_2w/train_shuffled.flist | xargs -I {} mv Datasets/ballet_bk_2w/Croped_temp/{} Datasets/ballet_bk_2w/train/
cat Datasets/ballet_bk_2w/val_shuffled.flist | xargs -I {} mv Datasets/ballet_bk_2w/Croped_temp/{} Datasets/ballet_bk_2w/val_source_256/

rmdir Datasets/ballet_bk_2w/Croped_temp

# create location config celeba.yaml
PWD=$(pwd)
DATASET=${PWD}/Datasets/ballet_bk_2w
CELEBA=${PWD}/configs/training/location/ballet_bk_2w.yaml

touch $CELEBA
echo "# @package _group_" >> $CELEBA
echo "data_root_dir: ${DATASET}/" >> $CELEBA
echo "out_root_dir: ${PWD}/experiments/" >> $CELEBA
echo "tb_dir: ${PWD}/tb_logs/" >> $CELEBA
echo "pretrained_models: ${PWD}/" >> $CELEBA