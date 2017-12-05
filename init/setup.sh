#!/bin/env bash

if [ ! -d "${HOME}/environment/python3" ]; then
    echo "Installing python3"
    virtualenv -p python3 ${HOME}/environment/python3
fi

source ${HOME}/environment/python3/bin/activate

pip install --upgrade -r ${HOME}/environment/aws-cloud9-dev-environment/init/requirements.txt
sudo yum -y install jq
git config --global credential.helper parameter-store

github_user=$(echo 'host=github.com' | git-credential-parameter-store get | sed -ne 's/^username=//p')
github_pass=$(echo 'host=github.com' | git-credential-parameter-store get | sed -ne 's/^password=//p')

for page in $(seq 1 10)
do
    for repo in $(curl -s -u ${github_user}:${github_pass} "https://api.github.com/user/repos?per_page=200&page=${page}" | jq -r '.[].full_name')
    do
        if [ ! -d "${HOME}/environment/${repo}" ]; then
            echo "Cloning repo ${repo}"
            git clone https://github.com/${repo}.git ${HOME}/environment/${repo}
        fi
    done
done
