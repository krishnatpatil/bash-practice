#!/usr/bin/env bash
#-------------------------------------------------------------------------------------
# NAME:
#    tools/sample-sign.sh
#
# USAGE:
#    sh tools/sample-sign.sh $(RPMDIR)/$(RPMNAME)-$(VERSION)-$(RELEASE).$(ARCH).rpm
#

RPM=$1
rpm-sign.exp $RPM
