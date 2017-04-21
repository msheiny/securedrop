#!/bin/bash
#
#
#

make ci-spinup && make ci-run
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
