#!/bin/env bash

if [ ! -d "${HOME}/environment/python3" ]; then
    echo "Installing python3"
    virtualenv -p python3 ${HOME}/environment/python3
fi

source ${HOME}/environment/python3/bin/activate

pip install --upgrade -r "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/requirements.txt
sudo yum -y install jq
git config --global credential.helper parameter-store

github_user=$(echo 'host=github.com' | git-credential-parameter-store get | sed -ne 's/^username=//p')
github_pass=$(echo 'host=github.com' | git-credential-parameter-store get | sed -ne 's/^password=//p')

git config --global user.name "$(curl -su ${github_user}:${github_pass} 'https://api.github.com/user' | jq -r '.name')"
git config --global user.email "$(curl -su ${github_user}:${github_pass} 'https://api.github.com/user' | jq -r '.email')"

for page in $(seq 1 10)
do
    for repo in $(curl -s -u ${github_user}:${github_pass} "https://api.github.com/user/repos?per_page=200&page=${page}" | jq -r '.[].full_name')
    do
        if [ ! -d "${HOME}/environment/${repo}" ]; then
            echo "Cloning repo ${repo}"
            git clone --depth 1 https://github.com/${repo}.git ${HOME}/environment/github.com/${repo}
        fi
    done
done
