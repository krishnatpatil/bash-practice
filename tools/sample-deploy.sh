#!/usr/bin/env bash
#-------------------------------------------------------------------------------------
# NAME:
#    tools/sample-deploy.sh
#
# USAGE:
#    sh tools/sample-deploy.sh $(ROLE) $(ROLE2) $(ROLE3) ...
#

for role in $*
do
    echo "Uploading RPM to server_role-$role yum repo..."
    scp *.rpm nprd1.test.com:/apps/yum/SILO/production/$role/RPMS/
    ssh -t ${USER}@nprd1.test.com "cd /apps/yum/SILO/production/$role/RPMS/; sudo chmod -R 775 .; sudo chown -R user:group .; sudo -u sudouser createrepo -c cache ."
done
