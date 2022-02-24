#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------
# NAME:
#    tools/check.sh
#
# DESCRIPTION:
#    Check script which performs basic testing.
#
# NEXT STEPS:
#    tools/build.sh
#

echo "--[CoDE]--[check.sh]------------------------------------------------------------------"
set -e

echo "--[CWD]-------------------------------------------------------------------------------"
pwd

echo "--[id]--------------------------------------------------------------------------------"
id

echo "--[env]-------------------------------------------------------------------------------"
env | sort

echo "--[ls -ltr]---------------------------------------------------------------------------"
ls -ltr

# need to add the python_2_7_14 path to the default python import path
export PATH=$PATH:/apps/Python-2.7.14/bin
export PYTHONPATH=$PYTHONPATH:/apps/Python-2.7.14/lib/python2.7

# Running pylint
echo "--[run_tests.sh]--[pylint]------------------------------------------------------------"
./tools/run_tests.sh -l

# Running Unit Tests
echo "--[run_tests.sh]--[unit tests]--------------------------------------------------------"
./tools/run_tests.sh -u

echo "--[cat results/coverage.xml]----------------------------------------------------------"
cat results/coverage.xml
echo "--[cat results/test-results.xml]------------------------------------------------------"
cat results/test-results.xml
