#!/usr/bin/env bash
#----------------------------------------------------------------------------------------
# NAME:
#    tools/sample-clean.sh
#
# USAGE:
#    cd `pwd`; sh tools/sample-clean.sh
#    cd `pwd`; sh tools/sample-clean.sh realclean
#
# DESCRIPTION:
#    Clean the normal things (first use case).
#    Include the generated RPM (second use case).
#

rm -rf BUILD BUILDROOT RPMS SRPMS
rm -rf .pytest_cache SOURCES/tests/__pycache__ cov_html .coverage SOURCES/tests/.coverage results

if  [ "$1" = "realclean" ]; then
    find . -name "*.rpm*" -exec /bin/rm {} \;
fi

echo "---------------------------------------------------------------------------------"
git status
