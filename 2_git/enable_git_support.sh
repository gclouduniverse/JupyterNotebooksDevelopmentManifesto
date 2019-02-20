#!/bin/bash

readonly DL_PATH="/opt/deeplearning"

if [[ -f "${DL_PATH}" ]]; then
    echo "This script will work correctly only on GCP DeepLearning VM."
    exit 1
fi

source /opt/c2d/c2d-utils || exit 1

sudo pip2 install nbdime
sudo pip3 install nbdime
if [[ -f /etc/profile.d/anaconda.sh ]]; then
    source /etc/profile.d/anaconda.sh
    "${ANACONDA_BIN}/pip" install nbdime
fi

sudo /usr/local/bin/nbdime config-git --enable --system

JUPYTER_USER="jupyter"
if [[ ! -z $(get_attribute_value jupyter-user) ]]; then
  JUPYTER_USER=$(get_attribute_value jupyter-user)
fi

sudo -u "${JUPYTER_USER}" jupyter serverextension enable --py nbdime
sudo jupyter labextension install nbdime-jupyterlab
sudo service jupyter restart
