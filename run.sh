#!/bin/bash

/usr/sbin/apache2ctl start
tail -f /var/log/apache2/access.log -f /var/log/apache2/error.log
# tail -f /dev/null
