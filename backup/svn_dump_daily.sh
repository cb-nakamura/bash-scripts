#!/bin/bash

SRCDIR="/var/www/svn/repos";
BAKDIR="/backup/`hostname -s`/subversion";
DUMPCMD="/var/admin/scripts/backup/svn-backup-dumps.py";
REPOS=`find ${SRCDIR} -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`;

for REPO in ${REPOS}; do
	[ ! -d ${BAKDIR}/${REPO}/incremental ] && mkdir -p ${BAKDIR}/${REPO}/incremental;
	${DUMPCMD} -qzi ${SRCDIR}/${REPO} ${BAKDIR}/${REPO}/incremental;
done;

