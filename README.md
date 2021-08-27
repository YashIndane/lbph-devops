# lbph-devops

![](https://raw.githubusercontent.com/YashIndane/repo-images/main/lbph-devops-flow-path.png)

## Working

Upload a folder (the name of the folder should be name of person) , which has 100 images of that person's face.

When the folder is uploaded to this repository, this triggers the `Jenkins job` via a hook trigger. The repo is now cloned inside the job workspace. 

The Jenkins job executes the `code-builder.sh` script. This script builds code to train the LBPH model and saves the models. Similarly the backend code for LBPH recognition is build and saved.

Now the new docker image is build and pushed to Docker hub, and then a rolling update command is executed by the `job`, so that the EKS cluster uses the updated image.


