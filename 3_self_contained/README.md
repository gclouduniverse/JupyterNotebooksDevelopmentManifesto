# Ability to submit self-contained notebooks for a background execution

To use integration:

* you need to have (or to create) GCP [DeepLearning VM](https://blog.kovalevskyi.com/deep-learning-images-for-google-cloud-engine-the-definitive-guide-bc74f5fb02bc)
* ssh to your VM (or use JupyterLab terminal)
* follow the instructions:
   * git clone https://github.com/gclouduniverse/JupyterNotebooksDevelopmentManifesto.git
   * cd JupyterNotebooksDevelopmentManifesto/3_self_contained
   * chmod +x ./enable_notebook_submission.sh
   * ./enable_notebook_submission.sh
* now you can use following 2 commands: execute_notebook_with_gpu and execute_notebook_with_cpu
