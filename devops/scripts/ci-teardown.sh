#!/bin/bash -x
#
#
#

export ANSIBLE_INVENTORY="localhost"
export RETRY_FILES_ENABLED=False

./devops/playbooks/aws-ci-teardown.yml --diff
