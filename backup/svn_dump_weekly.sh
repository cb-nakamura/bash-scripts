#!/bin/bash

SRCDIR="/var/www/svn/repos";
BAKDIR="/backup/`hostname -s`/subversion";
DUMPCMD="/var/admin/scripts/backup/svn-backup-dumps.py";
REPOS=`find ${SRCDIR} -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`;

for REPO in ${REPOS}; do
	[ ! -d ${BAKDIR}/${REPO}/full ] && mkdir -p ${BAKDIR}/${REPO}/full;
	${DUMPCMD} -qz ${SRCDIR}/${REPO} ${BAKDIR}/${REPO}/full;
	find ${BAKDIR}/${REPO}/full -type f -mtime +6 -exec rm -f {} \;
done;
