#!/bin/bash

CONTAINER=jupyter-cuda11.8-ub22-torch2.0-nlp-$(id -u -n)
IMG_NAME=jupyter/datascience-notebook/kuhp-notebook-cuda11.8-ub22-torch2.0-nlp
IMG_VERSION=0.0.2

# UIDで50000番台のポート番号に割り付け

UID=$(id -u)
HOST_PORT=$((UID * 10 + 40000)) # ホストのポート
TFB_PORT=$((UID * 10 + 40001)) # ホストのtensorboard用ポート

# 竹村研A5000用のマウント

set -x
docker stop $CONTAINER
docker rm $CONTAINER
docker create --name $CONTAINER \
    --gpus all \
    --user root \
    -e NB_UID=$(id -u) \
    -e NB_GID=$(id -g) \
    -p $HOST_PORT:8888 \
    -p $TFB_PORT:6006 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /mnt/sdb1/:/home/jovyan/ext/ssd \
    -v /mnt/sdc1/:/home/jovyan/ext/hdd \
    -v /home/$(id -u -n):/home/jovyan/personal \
    --privileged \
    --cap-add SYS_ADMIN \
    --cap-add DAC_READ_SEARCH \
    $IMG_NAME:$IMG_VERSION
docker cp jupyter_notebook_config.py $CONTAINER:/home/jovyan/.jupyter
docker start $CONTAINER

echo "Please access JupyterLab with port number "$HOST_PORT" for "$(id -u -n)", and Tensorboard on port number "$TFB_PORT"."
