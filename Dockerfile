FROM yashindane/lbph-base-image:v1

MAINTAINER Yash Indane

COPY . /faceapp

WORKDIR /faceapp

ENTRYPOINT python3 app_template.py
