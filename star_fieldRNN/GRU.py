import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.utils.data
import os
from ClassificationModel import ClassificationModel

class GRU(ClassificationModel):
    def __init__(self, input_dim=1, hidden_dims=3, nclasses=5, num_rnn_layers=4, dropout=0.2, bidirectional=False,
                 use_batchnorm=False, use_layernorm=False):

        super(GRU, self).__init__()

        self.nclasses=nclasses
        self.use_batchnorm = use_batchnorm
        self.use_layernorm = use_layernorm

        self.d_model = num_rnn_layers*hidden_dims

        if use_layernorm:
            self.inlayernorm = nn.LayerNorm(input_dim)
            self.clayernorm = nn.LayerNorm((hidden_dims + hidden_dims * bidirectional) * num_rnn_layers)

        self.lstm = nn.GRU(input_size=input_dim, hidden_size=hidden_dims, num_layers=num_rnn_layers,
                            bias=True, batch_first=True, dropout=dropout, bidirectional=bidirectional)

        if bidirectional:
            hidden_dims = hidden_dims * 2

        self.linear_class = nn.Linear(hidden_dims , nclasses, bias=True)

        if use_batchnorm:
            self.bn = nn.BatchNorm1d(hidden_dims)

    def _logits(self, x):

        #x = x.transpose(1,2)

        if self.use_layernorm:
            x = self.inlayernorm(x)

        outputs, last_state_list = self.lstm.forward(x)

        if self.use_batchnorm:
            b,t,d = outputs.shape
            o_ = outputs.view(b, -1, d).permute(0,2,1)
            outputs = self.bn(o_).permute(0, 2, 1).view(b,t,d)

        #outputs = last_state_list
        #print(outputs.shape)
        outputs = outputs.contiguous().view(outputs.shape[0]*outputs.shape[1], outputs.shape[2])
        logits = self.linear_class.forward(outputs)


        return logits

    def forward(self,x):
        logits = self._logits(x)

        logprobabilities = F.log_softmax(logits, dim=-1)
        # stack the lists to new tensor (b,d,t,h,w)
        return logprobabilities

    def save(self, path="model.pth", **kwargs):
        print("\nsaving model to "+path)
        model_state = self.state_dict()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        torch.save(dict(model_state=model_state,**kwargs),path)

    def load(self, path):
        print("loading model from "+path)
        snapshot = torch.load(path, map_location="cpu")
        model_state = snapshot.pop('model_state', snapshot)
        self.load_state_dict(model_state)
        return snapshot
