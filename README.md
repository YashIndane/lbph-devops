# lbph-devops

![](https://raw.githubusercontent.com/YashIndane/repo-images/main/lbph-devops-flow-path.png)

## Setup

The following things need to be present on the VM where the job will run:

### 1. Python

### 2. kubectl

Download by :

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install by :

```
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### 3. aws cli

```
yum install aws -y
```

### 4. git

```
yum install git -y
```

### 5. docker

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

### 6. cv2 

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

## Other Settings

### Adding Webhhook

### Jenkins Job

Select Build as Execute Shell ->

![](https://raw.githubusercontent.com/YashIndane/repo-images/main/jenkins_build.png)

### Log in to the DockerHub account

It is required to login from the Jenkins sever to the account on docker Hub where the new container-image will be pushed

```
docker login -u <account-username> -p <account-password>
```

### AWS login

It is required to login from the Jenkins server with the user account that created the `EKS cluster` in AWS.

```
aws configure
```

### Connecting to EKS cluster

Configure a EKS cluster in AWS and connect to it from the Jenkins server

```
aws eks update-kubeconfig --region <region> --name  <cluster-name>
```

To check if connected successfully run 

```
kubectl get nodes
```

### docker and jenkins setup

This has to be done so that Jenkins can run docker commands

```
systemctl start docker
```

```
usermod -aG docker jenkins
```

```
systemctl restart jenkins
```

```
setenforce 0
```

### Important Note

Name the initial deployment name `face-app-deployment` and name of EKS cluster as `face-app`

Initially any container-image can be used from this repo -> [Link](https://hub.docker.com/repository/docker/yashindane/lbphrecog)

## Working

Upload a folder (the name of the folder should be name of person) , which has 100 images of that person's face.

Code for getting the cropped face images -> [Link](https://github.com/YashIndane/face-cropper/blob/main/cropped_face_generator.py)

When the folder is uploaded to this repository, this triggers the `Jenkins job` via a hook trigger. The repo is now cloned inside the job workspace. 

The Jenkins job executes the `code_builder.sh` script. This script builds code to train the LBPH model and saves the models. Similarly the backend code for LBPH recognition is build and saved.

Now the new docker image is build and pushed to Docker hub, and then a rolling update command is executed by the `job`, so that the `EKS cluster` uses the updated image.
