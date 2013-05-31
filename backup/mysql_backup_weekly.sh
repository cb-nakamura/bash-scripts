#!/bin/bash

BAKDIR="/backup/`hostname -s`/mysql/weekly";
USER="root";
PASSWORD="XXXXXXXX";

[ ! -d ${BAKDIR} ] && mkdir -p ${BAKDIR};

mysqldump -u${USER} -p${PASSWORD} -A | gzip > ${BAKDIR}/`date +%Y%m%d`.all.dump.sql.gz;

find ${BAKDIR} -type f ! -name "`date +%Y%m%d`*" -exec rm -f {} \;;

