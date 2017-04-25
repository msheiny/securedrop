#!/bin/bash
#
#
#
. devops/ansible_env

# Only run test task (usually used in local testing)
if [ ! "$1" == "only_test" ]; then
    make ci-spinup && make ci-run
fi

if [ "$?" == "0" ]; then
    case "$CI_SD_ENV" in
    "staging")
        ./testinfra/test.py app-$CI_SD_ENV
        ./testinfra/test.py mon-$CI_SD_ENV
        ;;
    "development")
        ./testinfra/test.py development
        ;;
    esac
fi

if [ -z "$TEST_REPORTS" ]; then
    export TEST_REPORTS=`pwd`
fi
mkdir $TEST_REPORTS/junit || true
./testinfra/combine-junit.py *results.xml > $TEST_REPORTS/junit/junit.xml
