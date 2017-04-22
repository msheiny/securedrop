#!/bin/bash

export RETRY_FILES_ENABLED="False"
export ANSIBLE_INVENTORY="./devops/inventory/$CI_SD_ENV"
export ANSIBLE_SSH_ARGS="-F $HOME/.ssh/sshconfig-securedrop-ci-$BUILD_NUM -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

ansible-playbook install_files/ansible-base/securedrop-${CI_SD_ENV}.yml --skip-tags="grsec,local_build" -e primary_network_iface=eth0 -e install_local_packages=true
