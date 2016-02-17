#!/bin/bash
#########################################
# ubuntu ldap client script		          #
# Rajesh Rajendran <rajesh@pinch.red>	  #
# this script must run as root		      #
#########################################

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
#enabling ubuntu to login with username
echo "greeter-show-manual-login=true" >> //usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
