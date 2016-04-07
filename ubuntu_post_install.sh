#! /bin/bash

set -e

#install complete android or php development environment from scratch
#script by rajesh rajendran <rajesh.rajendran@protonmail.com>
# you need to set url path for downloading and change file names accordingly
#this script must use as root
#all downloads can be find under /media/old_files/installations/

if [ $UID -ne 0 ]; then
 echo "THIS SCRIPT MUST RUN AS ROOT USER"
 exit 1
fi

#define common variables
URL="192.168.1.103:12000"

# definig common function for installing common apps and ldap authentication

function common {

 #LIMITING SWAP USAGE AFTER 90% RAM USAGE
 echo "vm.swappiness = 10" >> /etc/sysctl.conf

 #CONFIGURING APT-CACHER CLIENT
 touch /etc/apt/apt.conf
 echo "Acquire::http { Proxy \"http://192.168.1.103:3142\"; };" > /etc/apt/apt.conf
 #HTOP
 apt-get install -y htop
 #installing ldap

 #installing needed files
 apt-get -y install libpam-ldap nscd
 #type ldap://<host>:<port>/
 #make local DB admin :yes
 #db requires login : no
 #give your ldap root passwd
 #nano /etc/nsswitch.conf
 auth-client-config -t nss -p lac_ldap
 #automatic home folder creation
 echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
 service nscd restart
 #enabling username login
 #echo "greeter-show-manual-login=true" >>  /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf 
 #installing basic ubuntu panel only for ubuntu to avoid unity 
 #apt-get install -y gnome-session-fallback
 
 #JDK
 wget $URL/JDK.tar.gz
 tar -xzf JDK.tar.gz -C /opt/
 update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_73/bin/java 100
 update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_73/bin/javac 100

 # INSTALLING CHROMIUM
 apt-get install -y chromium-browser
 
 #MELD
 apt-get install -y meld

 #INSTALLING ALBERT APP LAUNCHER
 #add-apt-repository ppa:nilarimogard/webupd8
 #apt-get update
 #apt-get install libqt5gui5
 #apt-get install -y albert

 #SVN AND SVN WORKBENCH
 apt-get install -y subversion
 apt-get install  -y svn-workbench
 #SPARK
 wget $URL/Spark.tar.gz
 tar -xzf Spark.tar.gz -C /opt/
 #CREATING MENU ENTRY
 wget -O /usr/share/applications/spark.desktop $URL/Spark.desktop 
}
function php {
 #install LAMP
 apt-get install -y apache2
 apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql
 #/usr/bin/mysql_secure_installation
 sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt memcached
 service apache2 restart
 #INSTALLING KOMODO-EDIT
 sudo add-apt-repository -y ppa:mystic-mirage/komodo-edit
 sudo apt-get update
 sudo apt-get install -y komodo-edit
 #PHP MY ADMIN
 apt-get install -y phpmyadmin apache2-utils
 service apache2 restart
}

function android {
	#ANDROID STUDIO
	wget $URL/android-studio.tar.gz
	tar -xzf android-studio.tar.gz -C /opt/
	wget -O /usr/share/applications/android-studio.desktop $URL/android-studio.desktop
	#gpick color picker
	apt-get install gpick
	#SQLITEBROWSER
	apt-get install -y sqlitebrowser
	}

if [ $1 = "--help" ] || [ -z "$1" ]; then
	echo -e "--php for php devs\n--android for android developers"
elif [ $1 == '--php' ]; then
	echo "do you want to make this system for a php dev? y/n"
	read ans
	if [ $ans = 'y' ]; then
		echo -e "please wait a second for the php developer system\nit might take a while"
		common
		php
		exit
	elif [ $ans = 'n' ]; then
		echo "quiting without making any change"
		exit
	fi
elif [ $1 == '--android' ]; then
	echo "do you want to make this system for a android dev? y/n"
	read ans
	if [ $ans = 'y' ]; then
		echo -e "please wait a second for the php developer system\nit might take a while"
		common
		android
		exit	
	elif [ $ans = 'n' ]; then
		echo "quiting without making any change"
		exit
	fi
fi
