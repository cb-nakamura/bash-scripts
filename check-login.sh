#!/bin/bash

SERVERS="www0
www1
www2";

for SERVER in $SERVERS; do
	expect -c "
	spawn ssh -o \"StrictHostKeyChecking no\" $SERVER 'hostname'
	expect 'password:'
	send PASSWORD\r
	interact
	"
done;
