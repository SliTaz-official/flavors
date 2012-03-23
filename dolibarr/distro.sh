#!/bin/sh
# distro.sh, changeset for slitaz-dolibarr
#
# Eric Joseph-Alexandre <erjo@slitaz.org>

ROOTFS=$PWD/rootfs
HOSTNAME="dolilive"
AUTOSTART="apache mysql"
DONTSTART="httpd"
ALLOW_ROOT_LOGIN="1"
BLOCKED_PACKAGES=""

# Disable auto-install dependencies
sed -i s/AUTO_INSTALL.*/AUTO_INSTALL_DEPS=\"no\"/ $ROOTFS/etc/slitaz/tazpkg.conf

##
##
if [ ! -z "$BLOCKED_PACKAGES" ]; then
	touch $ROOTFS/var/lib/tazpkg/blocked-packages.list
	for i in $BLOCKED_PACKAGES
	do 
		echo $i >> $ROOTFS/var/lib/tazpkg/blocked-packages.list
	done
fi


# Set static IP config: IP=92.168.1.6/24. Gateway=192.168.1.1 DNS: 192.168.1.1 

if [ ! -z  $IP_STATIC ]; then
	sed -i -e 's/DHCP=.*/DHCP=\"no\"/' \
		-e 's/STATIC=.*/STATIC=\"yes\"/' \
		-e 's/IP=.*/IP=\"192.168.1.6\"/' \
		-e 's/GATEWAY=.*/GATEWAY=\"192.168.1.1\"/' \
		-e 's/DNS_SERVER=.*/DNS_SERVER=\"192.168.1.1\"/' $ROOTFS/etc/network.conf
fi

# Change default hostname
if [ ! -z "$HOSTNAME" ]; then
	echo "* Setting hostname to $HOSTNAME"
	echo "$HOSTNAME" > $ROOTFS/etc/hostname
	# Change hosts
	sed -i -e "s/slitaz/$HOSTNAME/" $ROOTFS/etc/hosts
fi

# Start daemons at boot time
if [ ! -z "$AUTOSTART" ]; then 
	echo "* Enabling daemons at boot" 
	sed -i -e "s/RUN_DAEMONS=\"\(.*\)\"/RUN_DAEMONS=\"\1 $AUTOSTART\"/"  \
		$ROOTFS/etc/rcS.conf
fi

# Dont start daemons at boot time
if [ ! -z "$DONTSTART" ]; then 
	echo "* Disabling daemons at boot" 
	sed -i -e "s/$DONTSTART//"  \
		$ROOTFS/etc/rcS.conf
fi

##
## Custom config
##

# Allow SSH root login from remote computer.
if [ $ALLOW_ROOT_LOGIN = "1" ]; then
	echo "Allow root login using SSH"
	sed -i 's!DROPBEAR_OPTIONS=.*!DROPBEAR_OPTIONS="-b  /etc/dropbear/banner"!' \
	$ROOTFS/etc/daemons.conf
fi

# Fix Apache config
sed -i  '/#ServerName/ {
	a\ServerName localhost
}' $ROOTFS/etc/apache/httpd.conf

#
sed -i 's/DirectoryMatch/Directory/' $ROOTFS/etc/apache/conf.d/phpmyadmin

# Remove extra files
rm -rf $ROOTFS/etc/apache/phpinfo
rm -rf $ROOTFS/usr/share/applications/lua.*
rm -rf $ROOTFS/usr/share/applications/sqlite.*
rm -rf $ROOTFS/usr/share/applications/gtkdialog.*
rm -rf $ROOTFS/usr/share/applications/php.*
rm -rf $ROOTFS/usr/share/applications/dialog.*

# Default config
sed -i 's/tazweb/midori/' $ROOTFS/etc/slitaz/applications.conf

#
#~ sed -i 's/transparent=1/transparent=0/' $ROOTFS/usr/share/lxpanel/profile/default/panels/panel 
#~ sed -i 's/transparent=1/transparent=0/' $ROOTFS/etc/lxpanel/default/panels/panel 
#~ sed -i 's/transparent=1/transparent=0/' $ROOTFS/etc/lxpanel/original/panels/panel 
sed -i 's/tazweb/midori/' $ROOTFS/usr/share/lxpanel/profile/default/panels/panel 
sed -i 's/tazweb/midori/' $ROOTFS/etc/lxpanel/default/panels/panel  
sed -i 's/tazweb/midori/' $ROOTFS/etc/lxpanel/original/panels/panel 

#~ 
# fix perms (don't know why)
chmod 755 $ROOTFS/etc/mysql.d/*

# Add shortcut on the Desktop
cp $ROOTFS/usr/share/applications/dolibarr.desktop $ROOTFS/etc/skel/Desktop
#cp $ROOTFS/usr/share/applications/phpmyadmin.desktop $ROOTFS/etc/skel/Desktop
