#!/bin/bash

mysql -u root -plmX3Oxsaxy -e "SHOW SLAVE STATUS\G" | grep "Slave_IO_Running"

