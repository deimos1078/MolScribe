NUM_NODES=1
NUM_GPUS_PER_NODE=8
NODE_RANK=0

BATCH_SIZE=256
ACCUM_STEP=1

MASTER_PORT=$(shuf -n 1 -i 10000-65535)

python -m torch.distributed.launch \
    --nproc_per_node=$NUM_GPUS_PER_NODE --nnodes=$NUM_NODES --node_rank $NODE_RANK --master_addr localhost --master_port $MASTER_PORT \
    train.py \
    --formats atomtok \
    --input_size 528 \
    --encoder tf_efficientnet_b6 \
    --decoder_scale 2 \
    --save_path output/atomtok_efficientnet_b6 \
    --load_ckpt ep15 \
    --epochs 16 \
    --batch_size $((BATCH_SIZE / NUM_GPUS_PER_NODE / ACCUM_STEP)) \
    --gradient_accumulation_steps $ACCUM_STEP \
    --do_valid \
    --do_test \
    --beam_size 15 --n_best 10 \
    --fp16
    
#     --do_train \
#     --do_test \