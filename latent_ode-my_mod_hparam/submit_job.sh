#!/bin/bash
#BSUB -W 120:00
##BSUB -o /cluster/work/igp_psr/metzgern/Network/outputs/outputtrain_Le${object}.%J.%I.txt
##BSUB -e /cluster/work/igp_psr/metzgern/Network/outputs/train_Le${object}.%J.%I.txt
#BSUB -R "rusage[mem=32000,ngpus_excl_p=1]"
#BSUB -n 1
##BSUB -Is 
#BSUB -N
#BSUB -B
#### BEGIN #####


module load python_gpu/3.6.1 cudnn/7.5 cuda/10.0.13  pytorch/1.4.0 #.10.1 #2.7.14 #numpy/1.16.3 matplotlib/2.1.1 Keras/2.2.4


#sh test_cityscapes.sh

#python run_models.py --ode-rnn --ode-type gru -n 50000
python run_models.py --niters 60 -n 300000 -validn 60000 --ode-rnn --ode-type linear --stacking 2 --ode-method dopri5 --random-seed 6001 --num-search 10 --num-seeds 1 --hparams batch-size

# RNN
#python run_models.py --niters 60 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell gru --random-seed 6001 --num-search 1 --num-seeds 1