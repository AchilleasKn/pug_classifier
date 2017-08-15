# Docker and Deep Learning for Pugs ![pug](http://textemoticons.net/wp-content/uploads/2013/03/pugstanding.gif)

Repo for the Strata+Hadoop World 2016 talk ["Docker for Data Scientists"](http://conferences.oreilly.com/strata/hadoop-big-data-ca/public/schedule/detail/47475).

## Introduction

This repository comprises an end-to-end example of doing data science with docker.  We begin by doing interactive analysis and modeling in a jupyter notebook.  The task at hand is building a deep convolutional neural network that can recognize photos of pugs vs. photos of golden retrievers with transfer learning.  That is, we take [a pre-trained deep convolutional network](https://gist.github.com/baraldilorenzo/07d7802847aaad0a35d3) and retrain the last layer for our particular pug-recognition task.  Training can take place using docker on a CPU or on a GPU for speed.

Once the model is built and the weights are saved, we deploy a simple web app.  We serve model scores with another container running a simple flask API wrapper around the neural network model.  And we build a frontend using a container running R and Shiny.  Finally, both containers are run and linked together using docker-compose.

The data comes from URL's from [ImageNet](http://www.image-net.org/).  The `/data` directory of the project has the URL's as well as code for downloading them and normalizing the images.  There's also a gzipped pickle file stored in Git LFS so the user doesn't need to download all of the original images.

## Docker Images

- [Modeling: python3 + theano + jupyter notebook for the CPU](https://hub.docker.com/r/mdagost/pug_classifier_notebook/)
- [Modeling: python3 + theano + jupyter notebook for the GPU](https://hub.docker.com/r/mdagost/pug_classifier_gpu_notebook/)
- [API: python3 + theano + jupyter notebook + flask](https://hub.docker.com/r/mdagost/pug_classifier_flask/)
- [Frontend: R + shiny](https://hub.docker.com/r/mdagost/pug_classifier_shiny/)


## Interactive Notebook and Modeling on the CPU
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
git clone https://github.com/mdagost/pug_classifier.git
cd pug_classifier
curl http://pug-classifier.s3.amazonaws.com/cnn_pug_model_architecture.json > api/cnn_pug_model_architecture.json
curl http://pug-classifier.s3.amazonaws.com/cnn_pug_model_weights.h5 > api/cnn_pug_model_weights.h5
curl http://pug-classifier.s3.amazonaws.com/pugs_vs_golden_retrvrs_data.pkl.gz > data/pugs_vs_golden_retrvrs_data.pkl.gz
curl http://pug-classifier.s3.amazonaws.com/vgg16_weights.h5 > model/vgg16_weights.h5
```

Run the container:

```
eval $(docker-machine env awsnotebook)
docker run -d -p 8888:8888 -v /home/ubuntu/pug_classifier:/home/jovyan/work mdagost/pug_classifier_notebook
```

Get the IP of the instance:

```
docker-machine env awsnotebook
```

Visit http://{{IP}}:8888/ to use the notebook.  **Note:** if you're using AWS you may have to add an inbound rule to the docker-machine security group opening up port 8888.

## Interactive Notebook and Modeling on the GPU
Create a GPU instance:

```
docker-machine create --driver amazonec2 --amazonec2-access-key XXXX --amazonec2-secret-key XXXX --amazonec2-root-size 100 --amazonec2-instance-type g2.2xlarge --amazonec2-ami ami-76b2a71e awsgpunotebook
```

If you want the ec2 instance to be on a private VPN:

```
docker-machine create --driver amazonec2 --amazonec2-access-key XXXX --amazonec2-secret-key XXXX --amazonec2-root-size 100 --amazonec2-zone b --amazonec2-vpc-id vpc-XXXX --amazonec2-subnet-id subnet-XXXX --amazonec2-instance-type g2.2xlarge --amazonec2-private-address-only --amazonec2-ami ami-76b2a71e awsgpunotebook
```

SSH in:

```
docker-machine ssh awsgpunotebook
```

Set up the GPU following the instructions [here](https://github.com/mdagost/MScA_code/blob/master/lecture_08/bootstrap_aws_gpu.sh).

Install `nvidia-docker` like so:

```
git clone https://github.com/NVIDIA/nvidia-docker
cd nvidia-docker
sudo make install
sudo nvidia-docker volume setup
```

Get our software:

```
git clone https://github.com/mdagost/pug_classifier.git
cd pug_classifier
curl http://pug-classifier.s3.amazonaws.com/cnn_pug_model_architecture.json > api/cnn_pug_model_architecture.json
curl http://pug-classifier.s3.amazonaws.com/cnn_pug_model_weights.h5 > api/cnn_pug_model_weights.h5
curl http://pug-classifier.s3.amazonaws.com/pugs_vs_golden_retrvrs_data.pkl.gz > data/pugs_vs_golden_retrvrs_data.pkl.gz
curl http://pug-classifier.s3.amazonaws.com/vgg16_weights.h5 > model/vgg16_weights.h5
```

Run the container:

```
sudo nvidia-docker run -d -p 8888:8888 -v /home/ubuntu/pug_classifier:/home/ubuntu mdagost/pug_classifier_gpu_notebook
```

Get the IP of the instance:

```
docker-machine env awsnotebook
```

Visit http://{{IP}}:8888/ to use the notebook. **Note:** if you're using AWS you may have to add an inbound rule to the docker-machine security group opening up port 8888.


## Shiny App Hitting the Flask API

```
cd shiny/
docker-compose up
```

Get the IP of the docker VM:

```
docker-machine env default
```

Visit http://{{IP}}:3838/pugs/ and voila!

To run the app on AWS:

```
docker-machine create --driver amazonec2 --amazonec2-access-key XXXX --amazonec2-secret-key XXXX --amazonec2-root-size 100 --amazonec2-instance-type m3.large awsapp
eval $(docker-machine env awsapp)
cd shiny
docker-compose up
```

Get the IP of the AWS instance:

```
docker-machine env awsapp
```

Visit http://{{IP}}:3838/pugs/ and voila! **Note:** if you're using AWS you may have to add an inbound rule to the docker-machine security group opening up port 3838.
