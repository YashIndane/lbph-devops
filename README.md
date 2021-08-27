# lbph-devops

![](https://raw.githubusercontent.com/YashIndane/repo-images/main/lbph-devops-flow-path.png)

## Setup

The following things need to be present on the VM where the job will run:

### 1. git

```
yum install git -y
```

### 2. docker

For RHEL VM ->

Configure a repo for docker

```
[docker]
baseurl=https://download.docker.com/linux/centos/7/x86_64/stable/
gpgcheck=0
```

```
yum install docker-ce --nobest
```

For Amazon Linux ->

```
yum whatprovides docker
```

```
yum install <version-name-from-the-list>
```

### 3. cv2 

```
pip3 install --upgrade pip setuptools wheel
```

```
pip3 install opencv-python
```

```
yum install opencv opencv-devel opencv-python
```

LBPH requires a library called `opencv-contrib-python`

```
pip3 install opencv-contrib-python
```



## Working

Upload a folder (the name of the folder should be name of person) , which has 100 images of that person's face.

When the folder is uploaded to this repository, this triggers the `Jenkins job` via a hook trigger. The repo is now cloned inside the job workspace. 

The Jenkins job executes the `code_builder.sh` script. This script builds code to train the LBPH model and saves the models. Similarly the backend code for LBPH recognition is build and saved.

Now the new docker image is build and pushed to Docker hub, and then a rolling update command is executed by the `job`, so that the `EKS cluster` uses the updated image.
