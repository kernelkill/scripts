#!/bin/sh
# chkconfig: 345 98 99
# description: Tomcat auto start-stop script.
#
# Set OWNER to the user id of the owner of the Tomcat software.

OWNER=hightech

case "$1" in
    'start')
        su - $OWNER -c "/opt/tomcat8/bin/catalina.sh start >> /opt/tomcat8/logs/daemon-tomcat8.log 2>&1"
        touch /var/lock/subsys/tomcat8
        ;;
    'stop')
        su - $OWNER -c "/opt/tomcat8/bin/catalina.sh stop  >> /opt/tomcat8/logs/daemon-tomcat8.log 2>&1"
        rm -f /var/lock/subsys/tomcat8
        ;;
    *)
        echo "Uso: $0 {start|stop}" 
        RETVAL=1
esac

RESULT=`ps -ef | grep catalina | grep -v grep ` 
echo $RESULT

exit $RETVAL

