# pug_classifier
Deep Learning for Pugs

CPU
===
Work locally, or create an ec2 instance:

```
docker-machine create --driver amazonec2 --amazonec2-access-key XXXX --amazonec2-secret-key XXXX --amazonec2-root-size 100 --amazonec2-instance-type m3.large awsnotebook

```

If you want the ec2 instance to be on a private VPN:

```
docker-machine create --driver amazonec2 --amazonec2-access-key XXXX --amazonec2-secret-key XXXX --amazonec2-root-size 100 --amazonec2-zone b --amazonec2-vpc-id vpc-XXXX --amazonec2-subnet-id subnet-XXXX --amazonec2-instance-type m3.large --amazonec2-private-address-only awsnotebook

```

Get our software:

```
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install
git clone https://github.com/mdagost/pug_classifier.git
cd pug_classifier
git lfs pull
```

Run the container:

```
eval $(docker-machine env awsnotebook)
docker run -d -p 8888:8888 -v /home/ubuntu/pug_classifier:/home/jovyan/work mdagost/pug_classifier_notebook
```

GPU
===
Create a GPU instance:

```
docker-machine create --driver amazonec2 --amazonec2-access-key --amazonec2-secret-key --amazonec2-root-size 100 --amazonec2-zone b --amazonec2-vpc-id --amazonec2-subnet-id --amazonec2-instance-type g2.2xlarge --amazonec2-private-address-only --amazonec2-ami ami-76b2a71e awsgpunotebook
```

SSH in:

```
docker-machine ssh awsgpunotebook
```

Setup the GPU following the instructions [here](https://github.com/mdagost/MScA_code/blob/master/lecture_08/bootstrap_aws_gpu.sh):

Install `nvidia-docker` like so:

```
git clone https://github.com/NVIDIA/nvidia-docker
cd nvidia-docker
sudo make install
sudo nvidia-docker volume setup
```

Get our software:

```
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install
git clone https://github.com/mdagost/pug_classifier.git
cd pug_classifier
git lfs pull
```

Run the container:

```
sudo nvidia-docker run -d -p 8888:8888 -v /home/ubuntu/pug_classifier:/home/ubuntu mdagost/pug_classifier_gpu_notebook
```

