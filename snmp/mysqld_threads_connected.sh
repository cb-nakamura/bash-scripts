#!/bin/bash

mysql -uroot -p1bfa11a1 -BN -e "SHOW STATUS LIKE '%Threads_connected%'" | awk '{ print $2 }'

