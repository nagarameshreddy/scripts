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
systemctl enable xinetd
systemctl start xinetd
useradd nagios
wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar -xzvf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1
./configure
make
make install
cd ..
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.1.0/nrpe-3.1.0.tar.gz
tar -xzvf nrpe-3.1.0.tar.gz
cd nrpe-3.1.0
./configure
make all
make install
make install-config
make install-inetd
make install-init


systemctl restart xinetd
systemctl enable nrpe
systemctl start nrpe 
echo "edit the /usr/local/nagios/etc/nrpe.cfg file add server ip address and allowed hosts"
}

else

echo "Run this script as root user or with sudo command"
fi
