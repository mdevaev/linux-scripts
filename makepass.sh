#!/bin/bash
#
# Password generator based on MD5 hash
# by liksys (c) 2012 v1.0
#
#####


read_passwd() {
	stty_orig=`stty -g`
	stty -echo
	read passwd
	stty $stty_orig
	echo $passwd
}


echo -n "Password: "
first_passwd=`read_passwd`
echo
echo -n "Repeat password: "
second_passwd=`read_passwd`
echo

if [ "$first_passwd" != "$second_passwd" ]; then
	echo "Passwords does not match"
	exit 1
fi

passwd=`echo -n "$first_passwd$1" | md5sum | awk '{print $1}'`
if [ -n "$2" ]; then
	passwd=`expr substr $first_passwd 1 $2`
fi
echo "Generated: $passwd"

