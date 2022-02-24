#!/usr/bin/env bash
#-------------------------------------------------------------------------------------
# NAME:
#    tools/sample-coverage.sh
#
# DESCRIPTION:
#    Run pytest coverage report and emit HTML.
#

set -x

pylint --rcfile .pylintrc SOURCES/scripts

pytest --cov=SOURCES/scripts --cov-report html:cov_html SOURCES/tests
