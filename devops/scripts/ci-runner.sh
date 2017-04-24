#!/bin/bash

export RETRY_FILES_ENABLED="False"
export ANSIBLE_INVENTORY="./devops/inventory/$CI_SD_ENV"
export ANSIBLE_SSH_ARGS="-F $HOME/.ssh/sshconfig-securedrop-ci-$BUILD_NUM -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

if [ ! -d "install_files/ossec-packages/ansible/" ]; then
    git submodule update --init --recursive
fi

# Build OSSEC agent+server packages
ansible-playbook install_files/ossec-packages/ansible/build-deb-pkgs.yml -e build_path=/tmp/ossec-build -e repo_src_path="/tmp/ossec-src" -e local_build_path="../../../build/"

# Build + install OSSEC config packages, install securedrop
ansible-playbook install_files/ansible-base/securedrop-${CI_SD_ENV}.yml --skip-tags="grsec,local_build" -e primary_network_iface=eth0 -e install_local_packages=true -e ssh_users="$USER"
