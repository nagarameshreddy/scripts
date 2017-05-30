#! /bin/bash
#Nagios core installation script
echo"Nagios core installation script from JAVAHOME"
echo "Run this script as root user or sudo"
echo "conform that you are running with root user or sudo permissions(yes/no)"
read javahome
if ( [ "$javahome" = "yes" ] )
then {
#pre-requestices for Nagios core
yum -y install httpd php gd gd-devel gcc glibc glibc-common net-snmp wget unzip openssl openssl-devel
#Enable and start Apache Webserver
systemctl enable httpd
systemctl start httpd
#add nagios user
useradd nagios
#add nagcmd group
groupadd nagcmd
#add nagios and apache users to nagcmd group
usermod -G nagcmd nagios
usermod -G nagcmd apache
#Download and extract Nagios core
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.2.tar.gz
tar -xzvf nagios-4.3.2.tar.gz
cd nagios-4.3.2
#compile and install Nagios core
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf
echo "create password for nagiosadmin, which will be used to login into Nagios server"
printf "password\password" | htpasswd -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

#echo -e "password\password" | htpasswd -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

cd ..
#Download and install Nagios plugins
wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar -xzvf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1
./configure --with-nagios-user=nagios
./configure --with-nagios-group=nagcmd
make
make install
#change the selinux to permissive mode
setenforce 0
#Restart apache web server
systemctl restart httpd
#Enable and start nagios service
systemctl enable nagios
systemctl start nagios
cd ..
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.1.0/nrpe-3.1.0.tar.gz
tar -xzvf nrpe-3.1.0.tar.gz
cd nrpe-3.1.0
./configure
make check_nrpe
make install-plugin
}
else

echo "Run this script as root user or with sudo command"
fi
