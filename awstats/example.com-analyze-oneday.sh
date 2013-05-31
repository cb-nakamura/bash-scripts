#!/bin/bash

if [ $# != 1 ]; then
	echo "Invalid Argument.";
	echo "Usage : $0 YYYYMMDD";
	exit 2;
fi

SCRIPT="/var/www/awstats/awstats.pl";
TMPLOG="/tmp/example.com.access.log";
SITES="wsg niidome";

LOGS=` find /var/log/httpd/ -type f -name "access.log.http.${1}.gz" | sort`;

if [ -z ${LOGS} ]; then
	echo "Log File Not Found.";
	exit 2;
fi

for LOG in ${LOGS}; do
	zcat ${LOG} > ${TMPLOG};
	for SITE in ${SITES}; do
		[ -f ${TMPLOG} ] && ${SCRIPT} -config=example.com.${SITE} -update -logfile=${TMPLOG} > /dev/null;
		[ -f ${TMPLOG} ] && ${SCRIPT} -config=example.com.${SITE} -databasebreak=day -update -logfile=${TMPLOG} > /dev/null;
		${SCRIPT} -config=example.com.${SITE} -output > /var/www/awstats/${SITE}/index.html;
	done;
	[ -f ${TMPLOG} ] && rm -f ${TMPLOG};
done;

