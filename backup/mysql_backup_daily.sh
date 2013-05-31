#!/bin/bash

BAKDIR="/backup/`hostname -s`/mysql/daily";
TODAYS_BAKDIR="${BAKDIR}/`date +%Y%m%d`";

DATABASES="
cacti
mt
redmine
";
USER="root";
PASSWORD="XXXXXXXX";

[ ! -d ${TODAYS_BAKDIR} ] && mkdir -p ${TODAYS_BAKDIR};

for DB in ${DATABASES}; do
	mysqldump -u${USER} -p${PASSWORD} ${DB} | gzip > ${TODAYS_BAKDIR}/${DB}.dump.sql.gz;
done;

find ${BAKDIR} -type d -mtime +5 | xargs rm -rf;

