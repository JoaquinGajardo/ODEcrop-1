# Recurrent Neural Networks for Multitemporal Crop Identification

##### Source code of Rußwurm & Körner (2017) at [EARTHVISION 2017](https://www.grss-ieee.org/earthvision2017/)

When you use this code please cite
```
Rußwurm M., Körner M. (2017). Temporal Vegetation Modelling using Long Short-Term Memory Networks
for Crop Identification from Medium-Resolution Multi-Spectral Satellite Images. In Proceedings of the
IEEE Conference on Computer Vision and Pattern Recognition (CVPR) Workshops, 2017.
```

#### Tensorflow Graphs
The TensorFlow graphs for recurrent and convolutional networks are defined at ```rnn_model.py``` and ```cnn_model.py```.

#### Installation

##### Requirements

* [Tensorflow == 1.0.1](https://www.tensorflow.org/)
* [scikit-learn >= 0.18.1](http://scikit-learn.org/stable/)
* [numpy >= 1.11.2](http://www.numpy.org/)
* [pandas >= 0.19.1](http://pandas.pydata.org/)

A complete package list at ```requirements.txt```

**Please Note**: Due to changes in the tf.nn.rnn_cell.MultiRNN class in Tensorflow 1.2.0 the current code is not compatible with TF version 1.2.0

##### Installation
```
# clone this repository
git clone https://github.com/TUM-LMF/fieldRNN.git
cd fieldRNN

# download body of data to execute train.py and evaluate.py (~5 GB)
sh download_data.sh

# download tf checkpoints and svm baseline to run cvprwsevaluation.ipynb (~50 GB)
sh download_models.sh
```

The data is hosted at [mediaTUM](https://mediatum.ub.tum.de/1370728).

#### Network Training
The training is performed on *train* data, either from the database directly. The *test* (also referred to as *validation*) data is used logged in Tensorflow event files.

```
$ python train.py --help
positional arguments:
  layers                number of layers
  cells                 number of rnn cells, as multiple of 55
  dropout               dropout keep probability
  fold                  select training/evaluation fold to use
  maxepoch              maximum epochs

```

For instance:
```
python train.py 4 2 0.5 0 30 --gpu 0 --model lstm --savedir save
```
tensorflow checkpoint and eventfiles of this call will be stored at ```save/lstm/4l2r50d0f```

### Model Evaluation
The script ```evaluate.py``` evaluates one model based on *evaluation* data.

```
python evaluate.py models/lstm/2l4r50d9f
```
The latest checkpoint of one model is restored and the entire body of *evaluation* data is processed.
After the evaluation process ```eval_targets.npy```, ```eval_probabilities.npy``` and ```eval_observations.npy``` are stores in the ```save``` directory.
These files are later used for calculation of accuracy metrics by ```cvprwsevaluation.ipynb```

## Support Vector Machine baseline
Support Vector Machine for baseline evaluation is based on [scikit-learn](http://scikit-learn.org/stable/) framework

The script ```svm.py``` performes the gridsearch.
The generated files ```svm/scores.npy```, ```svm/targets.npy```,  ```svm/predicted.npy``` are needed for ```cvprwsevaluation.ipynb```

## Earthvision 2017 Evaluation

The (complete, but untidy) evaluation of plots and accuracy metrics can be founds at ```cvprwsevaluation.ipynb```

## Data

download train and test datasets of the first fold and the evaluation dataset via
```
sh download_data.sh
```
```data``` required for ```train.py``` and ```evaluate.py```

The data is stored as pickle files with dimensions 
raster data x as [batchsize, observations, features]
labels y as [batchsize, observations, features]

## Models
```models``` required for ```cvprwsevaluation.ipynb```

Resulting model checkpoints from the grid search can be downloaded (50 GB!) via 
```
sh download_models.sh
```

##### naming scheme
```4l5r50d5f``` represents 4 layers, x5 rnn_cells, 50% dropout keep probability, and fold 5

