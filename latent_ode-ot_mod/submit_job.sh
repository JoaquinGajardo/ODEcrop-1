#!/bin/bash
#BSUB -W 120:00
#BSUB -o outputs/lsf.0.%J.%I.txt
##BSUB -e /cluster/work/igp_psr/metzgern/Network/outputs/train_Le${object}.%J.%I.txt
#BSUB -R "rusage[mem=16000,ngpus_excl_p=1]"
#BSUB -n 1
##BSUB -Is 
#BSUB -N
#BSUB -B
#### BEGIN #####

module load eth_proxy
module load python_gpu/3.6.1 cudnn/7.5 cuda/10.0.13  pytorch/1.4.0 #.10.1 #2.7.14 #numpy/1.16.3 matplotlib/2.1.1 Keras/2.2.4


#python run_models.py --niters 1 -n 11000000 -validn 500000 --val_freq 200 --lrdecay 0.99999 --dataset swisscrop --swissdatatype 2_toplabels -b 800 --ode-rnn --rnn-cell star --stack-order ode_rnn --random-seed 6001 --num-search 1 --lr 0.00762 -g 100 -l 150 -u 255 --rec-layers 3 -v 2 --topper=True -BN=True --step 2 --trunc 9


#sh test_cityscapes.sh

# ODE-RNN
#python run_models.py --niters 20 --lr 0.00762 -n 300000 -validn 60000 -l 70 -u 255 --gru-units 100 --rec-layers 2 -b 600 --ode-rnn --rnn-cell gru --random-seed 6001 --num-search 1 --num-seeds 1 
#python run_models.py --niters 20 --lr 0.00762 -n 300000 -validn 60000 -l 70 -u 255 --gru-units 100 --rec-layers 2 --ode-rnn --ode-type linear --rnn-cell gru --ode-method dopri5 --random-seed 6001 --optimizer adamax --num-search 1 --num-seeds 1 --hparams
#python3 run_models.py --niters 25 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell gru --random-seed 6001 --num-search 1 --num-seeds 1 --lr 0.00762 -g 100 -l 70 -u 255 -v 2 --stack-order ode_rnn --topper=true -BN=true
#python3 run_models.py --niters 25 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell star --random-seed 6001 --num-search 1 --num-seeds 1 --lr 0.00762 -g 100 -l 70 -u 255 -v 2 --topper=true -BN=true

# ODE-GRU-(Bayes)
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 420 --lr 0.0084761 -l 177 -g 42 --ode-rnn --ode-type gru --rnn-cell gru --ode-method dopri5 --random-seed 6001 --optimizer adaw --num-search 10 --num-seeds 1 --hparams lr
#python3 run_models.py --niters 20 -n 300000 -validn 60000 -b 420 --lr 0.0084761 -l 177 -g 42 --ode-rnn --ode-type gru --rnn-cell gru --ode-method dopri5 --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 -v 2 -BN

# Stacking
#python3 run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --stacking 2 --ode-type linear --rnn-cell gru_small --ode-method dopri5 --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 -BN
#python run_models.py --niters 25 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell gru --random-seed 6001 --num-search 5 --num-seeds 1 --lr 0.00762 -g 100 -l 70 -u 255 --topper -BN --stacking 2 --hparams lr --resnet

# Stacking STAR
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 600 -BN --resnet --lr 0.0084761 -ODEws --ode-rnn -g 0 --stack-order ode_rnn ode_rnn ode_rnn --ode-type linear --rnn-cell star --ode-method euler --random-seed 6001 --optimizer adamax --num-search 15 --hparams lr

# Stacking of Residual layers ode_rnn
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --stack-order ode_rnn ode_rnn ode_rnn --ode-type gru --rnn-cell star --ode-method dopri5 --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 --topper -BN --resnet

# Stacking of Residual layers with weightsharing 88.04%
#python3 run_models.py --niters 20 -n 300000 -validn 60000 -b 600 -BN=true --resnet=true --lr 0.0084761 -g 78 --ode-rnn --stack-order ode_rnn ode_rnn ode_rnn --ode-type gru --rnn-cell star --ode-method euler --random-seed 6001 --optimizer adamax -ODEws=true

# Stacking of Residual layers with weightsharing
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 600 -BN --resnet --lr 0.0084761 -g 78 --ode-rnn --stack-order ode_rnn ode_rnn gru_small --ode-type gru --rnn-cell star --ode-method euler --random-seed 6001 --optimizer adamax -ODEws -RNNws --num-search 15 --hparams lr

# Stacking of Residual layers with weightsharing 
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --stacking 2 --ode-type linear --rnn-cell gru_small --ode-method euler --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 --topper -BN -ODEws
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --stacking 5 --ode-type linear --rnn-cell gru_small --ode-method euler --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 --resnet --topper -BN -ws

# combining 4xstar and one ODE
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --ode-type linear --rnn-cell gru_small --ode-method euler --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 --topper -BN --stack-order star star star star ode_rnn
#python run_models.py --niters 25 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell star --random-seed 6001 --num-search 5 --num-seeds 1 --lr 0.00762 -g 100 -l 70 -u 255 --topper -BN --stack-order ode_rnn ode_rnn ode_rnn--hparams lr --resnet

# combining one ODE and 4xstar
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --ode-type linear --rnn-cell gru_small --ode-method euler --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 --topper -BN --stack-order ode_rnn star star star star

# Stacking with shared weights
#python run_models.py --niters 40 -n 300000 -validn 60000 -b 600 --lr 0.0084761 -v 2 -l 18 --gru-units 18 --rec-layers 1 -u 40 --ode-rnn --stacking 5 -ws --ode-type linear --rnn-cell gru_small --ode-method dopri5 --random-seed 6001 --optimizer adamax --num-search 15 --num-seeds 1 --hparams

# RNN (Baseline)
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell gru --random-seed 6001 --num-search 1 --num-seeds 1 --stack-order gru -BN=true --topper=true
#python3 run_models.py --niters 20 -n 300000 -validn 60000 -b 600 --ode-rnn --rnn-cell lstm --random-seed 6001 --latents 40 -BN=true --topper=true

# 7xstar baseline
#python run_models.py --niters 20 -n 300000 -validn 60000 -b 400 --lr 0.0084761 --ode-rnn --random-seed 6001 --optimizer adaw --num-search 1 --num-seeds 1 --topper -BN --stack-order star star star star star star star



############################ Swiss data ############################

#python run_models.py --niters 1 -n 30000 -validn 50000 --hparams latents --dataset swisscrop --swissdatatype 2_toplabels -b 600 --ode-rnn --rnn-cell gru --stack-order ode_rnn --random-seed 6001 --num-search 3 --lr 0.00762 -g 100 -l 80 -u 255 -v 2 --topper=True -BN=True --step 2 --trunc 9
#python run_models.py --niters 1 -n 11000000 -validn 500000 --val_freq 200 --lrdecay 0.99999 --dataset swisscrop --swissdatatype 2_toplabels -b 500 --ode-rnn --rnn-cell gru --stack-order gru --random-seed 6001 --num-search 1 --lr 0.00762 -g 100 -l 20 -u 255 --rec-layers 2 -v 2 --topper=True -BN=True --step 2 --trunc 9

#Stacking swisscrop data
#python run_models.py --niters 1 -n 11000000 -validn 500000 --val_freq 200 --lrdecay 0.99999 --dataset swisscrop --swissdatatype 2_toplabels -b 400 --ode-rnn --rnn-cell star --stack-order ode_rnn ode_rnn gru -ODEws=True -RNNws=True -RN=True --random-seed 6001 --num-search 1 --lr 0.00762 -g 100 -l 100 -u 255 --rec-layers 2 -v 2 --topper=True -BN=True --step 2 --trunc 9


wandb agent cropteam/odecropclassification/3z6dqqnp