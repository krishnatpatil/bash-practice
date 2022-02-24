#!/usr/bin/env bash
#-------------------------------------------------------------------------------------
# NAME:
#    tools/sample-test.sh
#
# DESCRIPTION:
#    Run python test scripts.
#

RPM=$1
rpm -q --filesbypkg -p $RPM

pytest -vv SOURCES/tests
