#!/bin/bash

find /var/log/httpd/*/ -type f ! -name "*`date +%Y%m%d`*" ! -name "*.gz" | xargs gzip

