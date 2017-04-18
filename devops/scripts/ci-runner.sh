#!/bin/bash

export RETRY_FILES_ENABLED="False"
export ANSIBLE_INVENTORY="./devops/inventory/$CI_SD_ENV"
export ANSIBLE_SSH_ARGS="-F $HOME/.ssh/sshconfig-securedrop-ci-$TRAVIS_BUILD_NUMBER -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

ansible-playbook install_files/ansible-base/build-deb-pkgs.yml --skip-tags=local_build