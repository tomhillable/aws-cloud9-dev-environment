#!/bin/bash

virtualenv -p python3 ~/environment/python3
source ~/environment/python3/bin/activate
pip install awscli
git clone https://github.com/tomhillable/aws-datapipeline-s3-copy.git ~/environment/aws-datapipeline-s3-copy