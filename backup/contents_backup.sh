#!/bin/bash

BAKDIR="/backup/`hostname -s`/contents";
SRCDIRS="
var/spool/anacron
var/spool/at
var/spool/cron
var/www
home/
etc/
";

[ ! -d ${BAKDIR} ] && mkdir -p ${BAKDIR};

cd /;
tar -czf ${BAKDIR}/`date +%Y%m%d`.contents.tar.gz ${SRCDIRS} 1> /dev/null;

find ${BAKDIR} -type f ! -name "`date +%Y%m%d`.contents.tar.gz" -exec rm -f {} \;;

