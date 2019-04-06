#!/bin/bash

readonly DL_PATH="/opt/deeplearning"

if [[ -f "${DL_PATH}" ]]; then
    echo "This script will work correctly only on GCP DeepLearning VM."
    exit 1
fi

if [[ -f "${HOME}/.bashrc" ]]; then
    touch "${HOME}/.bashrc"
fi

if cat "${HOME}/.bashrc" | grep -q execute_notebook_with_cpu; then
    echo "Already enabled"
    source $HOME/.bashrc
    exit 0
fi

readonly NOTEBOOK_UTILS_PATH="${HOME}/.notebook_utils.sh"

wget https://raw.githubusercontent.com/gclouduniverse/gcp-notebook-executor/v0.1.2/utils.sh -O "${NOTEBOOK_UTILS_PATH}"

cat <<-'EOH' >> "${HOME}/.bashrc"
readonly NOTEBOOK_UTILS_PATH="${HOME}/.notebook_utils.sh"

function execute_notebook_with_gpu() {
    if [ "$#" -ne 4 ]; then
        echo "Usage: "
        echo "   ./execute_notebook_with_gpu [INPUT_NOTEBOOK] [GCS_TEMP_LOCATION] [GPU_TYPE] [GPU_COUNT]"
        echo ""
        echo "example:"
        echo "   ./execute_notebook_with_gpu test.ipynb gs://my-bucket p100 4"
        echo ""
        return 1
    fi 
    INSTANCE_NAME=$1
    GCP_PATH=$2
    GPU_TYPE=$3
    GPU_COUNT=$4
    execute_execute_notebook -i "${INSTANCE_NAME}" -o "${GCP_PATH}" -f tf-latest-gpu -g "${GPU_TYPE}" -c "${GPU_COUNT}"
    return $?
}

function execute_notebook_with_cpu() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: "
        echo "   ./execute_notebook_with_cpu [INPUT_NOTEBOOK_NAME] [GCS_TEMP_LOCATION]"
        echo ""
        echo "example:"
        echo "   ./execute_notebook_with_cpu test.ipynb gs://my-bucket"
        echo ""
        return 1
    fi 
    execute_execute_notebook -i "${INSTANCE_NAME}" -o "${GCP_PATH}" -f tf-latest-cpu
    return $?
}
EOH

source $HOME/.bashrc

git clone --branch v0.2.0 https://github.com/gclouduniverse/nova-jupyterlab-extensions.git "${HOME}/.nova"
cd "${HOME}/.nova"
sudo pip3 uninstall -y jupyterlab-nova
sudo pip3 install .
sudo service jupyter restart
sudo jupyter labextension install

git clone https://github.com/gclouduniverse/nova-agents.git "${HOME}/.nova-agents"
cd "${HOME}/.nova-agents"
git checkout 99497d902c50440ccabd1e8748fee490d6cb2c14
sudo cp ./nova-local-agent.sh /usr/bin/
sudo cp ./nova-runner-agent.sh /usr/bin/
sudo cp ./utils.sh /usr/bin/
sudo cp ./nova.service /lib/systemd/system/

sudo systemctl --no-reload --now enable /lib/systemd/system/nova.service
sudo service nova start
