#! /bin/bash
#NRPE plugin installation script
echo"NRPE plugin installation script from JAVAHOME"
echo "Run this script as root user or sudo"
echo "conform that you are running with root user or sudo permissions(yes/no)"
read javahome
if ( [ "$javahome" = "yes" ] )
then {
setenforce 0
yum install gcc glibc glibc-common gd gd-devel openssl openssl-devel net-snmp -y
yum -y install xinetd
yum install nagios-plugins-all nagios-plugins-nrpe nrpe -y
service nrpe start
chkconfig nrpe on
}

else

echo "Run this script as root user or with sudo command"
fi
