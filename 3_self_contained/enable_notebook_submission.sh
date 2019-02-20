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

cat <<-'EOH' >> "${HOME}/.bashrc"

readonly DEFAULT_NOTEBOOK_EXECUTOR_INSTANCE_NAME="notebookexecutor"

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
    IMAGE_FAMILY="tf-latest-cu100" # or put any required
    ZONE="us-west1-b"
    INSTANCE_NAME="${DEFAULT_NOTEBOOK_EXECUTOR_INSTANCE_NAME}"
    INSTANCE_TYPE="n1-standard-8"
    INPUT_NOTEBOOK=$1
    TEMP_GCS_LOCATION=$2
    INPUT_NOTEBOOK_GCS_PATH="${TEMP_GCS_LOCATION}/${INPUT_NOTEBOOK}"
    GPU_TYPE=$3
    GPU_COUNT=$4
    gsutil cp "./${INPUT_NOTEBOOK}" "${TEMP_GCS_LOCATION}"
    if [[ $? -eq 1 ]]; then
        echo "Upload to the temp GCS location (${TEMP_GCS_LOCATION}) of the notebook (./${INPUT_NOTEBOOK}) have failed."
        return 1
    fi
    gcloud compute instances create "${INSTANCE_NAME}" \
            --zone="${ZONE}" \
            --image-family="${IMAGE_FAMILY}" \
            --image-project=deeplearning-platform-release \
            --maintenance-policy=TERMINATE \
            --accelerator="type=nvidia-tesla-${GPU_TYPE},count=${GPU_COUNT}" \
            --machine-type="${INSTANCE_TYPE}" \
            --boot-disk-size=200GB \
            --scopes=https://www.googleapis.com/auth/cloud-platform \
            --metadata="input_notebook=${INPUT_NOTEBOOK_GCS_PATH},output_notebook=${TEMP_GCS_LOCATION},startup-script-url=https://raw.githubusercontent.com/b0noI/gcp-notebook-executor/master/notebook_executor.sh" \
            --quiet
    if [[ $? -eq 1 ]]; then
        echo "Creation of background instance for trainin have failed."
        return 1
    fi
    wait_till_instance_not_exist "${INSTANCE_NAME}" "${ZONE}"
    echo "execution has been finished, downloading the result (notebook.ipynb)"
    gsutil cp "${TEMP_GCS_LOCATION}/notebook.ipynb" .
    if [[ $? -eq 1 ]]; then
        echo "There was a problem with downloading result notebook (${TEMP_GCS_LOCATION}/notebook.ipynb)."
        return 1
    fi
    echo "done"
    return 0
}

function wait_till_instance_not_exist() {
    INSTANCE_NAME=$1
    ZONE=$2
    if [ "$#" -ne 2 ]; then
        echo "Usage: "
        echo "   ./wait_till_instance_not_exist [INSTANCE_NAME] [ZONE]"
        echo ""
        echo "example:"
        echo "   ./wait_till_instance_not_exist instance1 us-west1-b"
        echo ""
        return 1
    fi
    while true; do
        if gcloud compute instances describe "${INSTANCE_NAME}" --zone="${ZONE}" > /dev/null; then
            echo "Background execution still in progress, going to sleep 10sec..."
            sleep 10
            continue
        fi
        return 0
    done
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
    IMAGE_FAMILY="tf-latest-cpu" # or put any required
    ZONE="us-west1-b"
    INSTANCE_NAME="${DEFAULT_NOTEBOOK_EXECUTOR_INSTANCE_NAME}"
    INSTANCE_TYPE="n1-standard-8"
    INPUT_NOTEBOOK=$1
    TEMP_GCS_LOCATION=$2
    INPUT_NOTEBOOK_GCS_PATH="${TEMP_GCS_LOCATION}/${INPUT_NOTEBOOK}"
    gsutil cp "./${INPUT_NOTEBOOK}" "${TEMP_GCS_LOCATION}"
    if [[ $? -eq 1 ]]; then
        echo "Upload to the temp GCS location (${TEMP_GCS_LOCATION}) of the notebook (./${INPUT_NOTEBOOK}) have failed."
        return 1
    fi
    gcloud compute instances create "${INSTANCE_NAME}" \
            --zone="${ZONE}" \
            --image-family="${IMAGE_FAMILY}" \
            --image-project=deeplearning-platform-release \
            --machine-type="${INSTANCE_TYPE}" \
            --boot-disk-size=200GB \
            --scopes=https://www.googleapis.com/auth/cloud-platform \
            --metadata="input_notebook=${INPUT_NOTEBOOK_GCS_PATH},output_notebook=${TEMP_GCS_LOCATION},startup-script-url=https://raw.githubusercontent.com/b0noI/gcp-notebook-executor/master/notebook_executor.sh" \
            --quiet
    if [[ $? -eq 1 ]]; then
        echo "Creation of background instance for trainin have failed."
        return 1
    fi
    wait_till_instance_not_exist "${INSTANCE_NAME}" "${ZONE}"
    echo "execution has been finished, downloading the result (notebook.ipynb)"
    gsutil cp "${TEMP_GCS_LOCATION}/notebook.ipynb" .
    if [[ $? -eq 1 ]]; then
        echo "There was a problem with downloading result notebook (${TEMP_GCS_LOCATION}/notebook.ipynb)."
        return 1
    fi
    echo "done"
    return 0
}
EOH

source $HOME/.bashrc
