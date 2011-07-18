#!/bin/bash
#
# Script for add all avails ssh keys
# by liksys (c) 2010 v 1.0
#
#####

for key in `ls ~/.ssh/id_* | grep -v '\.pub'`; do ssh-add $key; done

