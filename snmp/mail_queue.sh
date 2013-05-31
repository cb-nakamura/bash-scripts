#!/bin/bash

/usr/bin/mailq | grep -v "Queue" | egrep -e "^[A-Z0-9]{11} " | wc -l
