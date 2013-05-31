#!/bin/bash


# INTERFACE
ETH0="192.168.2.10"
ETH1="XX.XX.XX.XX"

# LOCAL NETWORKS
MYNET0="192.168.2.0/24"
MYNET1="XX.XX.XX.XX/28"

# OTHER
HOME="YY.YY.YY.YY"

# confirm
echo "*** going to update iptables rules. ***"
read -p "continue?? (yes/no) : " ACTION

[ ! "${ACTION}" = "yes" ] && exit


# enable
enablefw () {
# flush
/sbin/iptables -F
# default policy
/sbin/iptables -P INPUT DROP
/sbin/iptables -P FORWARD DROP
/sbin/iptables -P OUTPUT ACCEPT
# established packets
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# allow local loopback
/sbin/iptables -A INPUT -i lo -j ACCEPT


# INPUT #####################################################################
##### ICMP #####
/sbin/iptables -A INPUT -p icmp --icmp-type 8 -s ${HOME} -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 0 -s ${HOME} -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 8 -s ${MYNET0} -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type 0 -s ${MYNET0} -j ACCEPT

##### FTP #####
/sbin/iptables -A INPUT -p tcp -m state --state NEW --dport 21 -j ACCEPT

##### SSH #####
/sbin/iptables -A INPUT -p tcp -m state --state NEW -s ${HOME} --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m state --state NEW -s ${MYNET0} --dport 22 -j ACCEPT

##### SSH DROP LOGS #####
/sbin/iptables -A INPUT -p tcp --dport 22 -j LOG --log-level info --log-prefix "[IPTABLES_SSH_LOG] "

##### HTTP #####
/sbin/iptables -A INPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT

##### SNMP #####
/sbin/iptables -A INPUT -p udp -s ${MYNET0} --dport 161 -j ACCEPT

##### HTTPS #####
/sbin/iptables -A INPUT -p tcp -m state --state NEW --dport 443 -j ACCEPT

##### FTP PASSIVE PORT #####
/sbin/iptables -A INPUT -p tcp -m state --state NEW --dport 4060:4090 -j ACCEPT


# FORWARD ####################################################################
# NO ENTRY



# OUTPUT #####################################################################
# NO ENTRY



echo "
updated iptables rules.
now make sure you can connect this server with ssh.
"
}

# initialize
flashfw () {
for a in `cat /proc/net/ip_tables_names`; do
	if [ $a == nat ]; then
		/sbin/iptables -t nat -P PREROUTING ACCEPT
		/sbin/iptables -t nat -P POSTROUTING ACCEPT
		/sbin/iptables -t nat -P OUTPUT ACCEPT
	elif [ $a == mangle ]; then
		/sbin/iptables -t mangle -P PREROUTING ACCEPT
		/sbin/iptables -t mangle -P INPUT ACCEPT
		/sbin/iptables -t mangle -P FORWARD ACCEPT
		/sbin/iptables -t mangle -P OUTPUT ACCEPT
		/sbin/iptables -t mangle -P POSTROUTING ACCEPT
	elif [ $a == filter ]; then
		/sbin/iptables -t filter -P INPUT ACCEPT
		/sbin/iptables -t filter -P FORWARD ACCEPT
		/sbin/iptables -t filter -P OUTPUT ACCEPT
	fi
	/sbin/iptables -F -t $a
	/sbin/iptables -X -t $a
done
}

# initialize, enable, wait 5 seconds.
flashfw && enablefw && sleep 5

# save iptables rules.
read -p "IPTABLES ルールを保存しますか??(yes/no) : " SAVE_ACTION
if [ "${SAVE_ACTION}" = "yes" ]; then
	#enablefw
	/etc/init.d/iptables save
else
	flashfw
	/etc/init.d/iptables save
fi

