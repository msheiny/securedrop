#!/bin/bash

. devops/ansible_env

if [ ! -d "install_files/ossec-packages/ansible/" ]; then
    git submodule update --init --recursive
fi

# Set hostnames for CI boxes based on inventory names
ansible staging -b -m hostname -a "name={{inventory_hostname}}"

# Hotfix for missing hostname attached to localhost
ansible staging -b -m lineinfile -a "dest=/etc/hosts line='127.0.0.1 localhost {{inventory_hostname}}' regexp='^127\.0\.0\.1'"

# Quick hack to pass IPs off to testinfra
for host in app mon; do
    # tacking xargs at the end strips the trailing space
    ip=`ssh -F $HOME/.ssh/sshconfig-securedrop-ci-$BUILD_NUM ${host}-$CI_SD_ENV "hostname -I" | xargs`
    ansible -c local localhost -m lineinfile -a "dest=./testinfra/vars/app-${CI_SD_ENV}.yml line='${host}_ip: $ip' regexp='^${host}_ip'"
    ansible -c local localhost -m lineinfile -a "dest=./testinfra/vars/mon-${CI_SD_ENV}.yml line='${host}_ip: $ip' regexp='^${host}_ip'"
done

# Build OSSEC agent+server packages
ansible-playbook install_files/ossec-packages/ansible/build-deb-pkgs.yml -e build_path=/tmp/ossec-build -e repo_src_path="/tmp/ossec-src" -e local_build_path="../../../build/"

# Build + install OSSEC config packages, install securedrop
ansible-playbook install_files/ansible-base/securedrop-${CI_SD_ENV}.yml --skip-tags="grsec,local_build" -e primary_network_iface=eth0 -e install_local_packages=true -e ssh_users="$USER"

# Reboot and wait
./devops/playbooks/reboot_and_wait.yml --diff
