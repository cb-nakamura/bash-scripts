#!/bin/bash

SCRIPT="/var/www/awstats/awstats.pl";
TMPLOG="/tmp/example.access.log";
SITES="blog";

LOGS=` find /var/log/httpd/ -type f -name "access.log.http.*.gz" | sort`;

for LOG in ${LOGS}; do
	# 解凍
	zcat ${LOG} > ${TMPLOG};
	for SITE in ${SITES}; do
	# 集計
		[ -f ${TMPLOG} ] && ${SCRIPT} -config=example.com.${SITE} -update -logfile=${TMPLOG};
		[ -f ${TMPLOG} ] && ${SCRIPT} -config=example.com.${SITE} -databasebreak=day -update -logfile=${TMPLOG};
		# HTML に出力
		${SCRIPT} -config=example.com.${SITE} -output > /var/www/awstats/${SITE}/index.html;
	done;
	# 一時ログ削除
	[ -f ${TMPLOG} ] && rm -f ${TMPLOG};
done;

