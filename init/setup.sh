#!/bin/env bash

if [ ! -d "${HOME}/environment/python3" ]; then
    echo "Installing python3"
    virtualenv -p python3 ${HOME}/environment/python3
fi

source ${HOME}/environment/python3/bin/activate

pip install --upgrade -r ${HOME}/environment/aws-cloud9-dev-environment/init/requirements.txt
git config --global credential.helper parameter-store

repos=(
    "aws-datapipeline-s3-copy"
    "alice"
    "dockerfiles"
    "git-credential-parameter-store"
)

for repo in "${repos[@]}"
do
    if [ ! -d "${HOME}/environment/${repo}" ]; then
        echo "Cloning repo ${repo}"
        git clone https://github.com/tomhillable/${repo}.git ${HOME}/environment/${repo}
    fi
done