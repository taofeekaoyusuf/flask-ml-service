#!/usr/bin/env bash

git clone git@github.com:imhofmi/flask-sklearn.git
make setup
source ~/.flask-sklearn/bin/activate
cd flask-sklearn
make all
az webapp up -n flask-sklearn --sku F1