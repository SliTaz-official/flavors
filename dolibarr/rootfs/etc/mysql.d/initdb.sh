#!/bin/sh
#
# dolibarr.sh, Configuration et installation de Dolibarr.
#
# (C) 2007-2015 SliTaz - GNU General Public License v3.
#
# Author : Eric Joseph-Alexandre <erjo@slitaz.org>

PACKAGE=Dolibarr
VER=0.1
PATH=/bin:/sbin:/usr/bin
CACHE=/var/slitaz
LOG=/var/log/$(basename $0).log

# Create cache directory if necessary
if [ ! -d $CACHE ]; then
	echo "Init cache/var directory" > $LOG
	mkdir -p $CACHE
	echo "Install/restore $PACKAGE database(s)"
	tazpkg reconfigure dolibarr
fi
