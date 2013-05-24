#!/bin/bash

IP_REGEXP='[0-9]{1,3}(\.[0-9]{1,3}){3}'
USER_REGEXP='[a-z_][a-z0-9_-]*'
ASSHOLES_REGEXP="(Failed password for invalid user $USER_REGEXP from $IP_REGEXP)|(Failed password for $USER_REGEXP from $IP_REGEXP)"

parse_assholes() {
	IFS=$'\n'
	for row in `grep -Eo "$ASSHOLES_REGEXP" "$1" | grep -Eo "$IP_REGEXP" | sort | uniq -c`; do
		local retries=`echo $row | awk '{print $1}'`
		[ "$retries" -le "$2" ] || (echo $row | awk '{print $2}') # print ip
	done
	unset IFS
}

select_new() {
	diff -u \
			<(iptables -L INPUT -n | grep '^DROP' | grep ' asshole ' | awk '{print $4}' | grep -Eo "$IP_REGEXP" | sort) \
			<(sort) \
		| grep '+[^+]' | grep -Eo $IP_REGEXP
}

ban_assholes() {
	while read ip; do
		#echo $ip
		iptables -I INPUT -s "$ip" -j DROP -m comment --comment asshole
	done
}

if [ -z "$1" -o -z "$2" ]; then
	echo "usage: $0 [/var/log/auth.log] [limit]"
	exit 1
fi
parse_assholes "$1" "$2" | select_new | ban_assholes

