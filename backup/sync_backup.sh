#!/bin/bash

BKUSER="bkadmin";
LOCAL="localhost";
REMOTE="remote";
BAKDIR="/backup";
SSHKEY="/PATH/TO/SSHKEY";
export RSYNC_RSH="ssh -i ${SSHKEY}";
OPT="-a";

rsync ${OPT} ${BAKDIR}/${LOCAL}/ ${BKUSER}@${REMOTE}:/backup/${LOCAL}/;
rsync ${OPT} ${BKUSER}@${REMOTE}:/backup/${REMOTE}/ ${BAKDIR}/${REMOTE}/;

