#!/bin/bash
#

#############################################################################################
#
# Brief: Script for patching VueScan 9 x64 Linux x86_64
# Author: cipherhater <https://gist.github.com/cipherhater>
# Copyright: © 2019 CipherHater, Inc.
#
#############################################################################################

#
##
### Colored output ##########################################################################

RESTORE='\001\033[0m\002'
RED='\001\033[00;31m\002'
GREEN='\001\033[00;32m\002'
YELLOW='\001\033[00;33m\002'
BLUE='\001\033[00;34m\002'
MAGENTA='\001\033[00;35m\002'
PURPLE='\001\033[00;35m\002'
CYAN='\001\033[00;36m\002'
LIGHTGRAY='\001\033[00;37m\002'
LRED='\001\033[01;31m\002'
LGREEN='\001\033[01;32m\002'
LYELLOW='\001\033[01;33m\002'
LBLUE='\001\033[01;34m\002'
LMAGENTA='\001\033[01;35m\002'
LPURPLE='\001\033[01;35m\002'
LCYAN='\001\033[01;36m\002'
WHITE='\001\033[01;37m\002'

echo -en ${RESTORE}

#
##
### Supported version #######################################################################

version_vuescan='9.6.44'

#
##
### Start menu ##############################################################################

echo -en ${LYELLOW} "\nThis script supports only: \n\n \
	${GREEN}Platform: ${WHITE} Linux x86_64\n\n \
	${GREEN}VueScan 9 x64 (v9.6.44): ${LMAGENTA} $version_vuescan\n\n"

echo -en ${RESTORE}

#
##
### Function for VueScan 9 ##################################################################

function vuescanPatching {
echo -en ${YELLOW} '\nChecking VueScan path ...\n'

if [[ -f './vuescan' ]]; then 
	p='.'
else
	echo -en ${WHITE} 
	read -r -p "Please input VueScan installed path (the directory contains vuescan): \
			    `echo $'\n> '`" p

	if [[ ! -d "$p" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a directory!\n\n'
	    echo -en ${RED} 'Goodbay!\n\n'
	    echo -en ${RESTORE}
	    exit 11
	fi

	if [[ ! -f "$p/vuescan" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a VueScan installed path!\n\n'
	    echo -en ${RESTORE}
	    echo -en ${RED} 'Goodbay!\n\n'
	    exit 12
	fi

	# Replace "\" with "/"
	p=$(echo $p | sed 's/\\/\//g')

	# Trim trailing "/"
	p=${p%/}
fi

echo -en ${RED} '\n'
read -p 'Backup VueScan 9 binary? [y/n]: ' bt
    if [ -n $bt ] && [ $bt != "n" ]; then
	# Backup VueScan
	echo -en ${GREEN} '\nRunning backup: copy "vuescan" to "vuescan.orig" ...\n'
	cp -i "$p/vuescan" "$p/vuescan.orig"
	echo
    fi
echo -en ${RESTORE}
}


#
##
### Function select which program to patch ##################################################

function mainWork {
echo -en ${WHITE}
read -n1 -p "Pick a letter to run patching: V - VueScan 9, or E - Exit script." runPatching

case $runPatching in
	v|V) printf "\n\nStart patching VueScan 9 x64.\n" && vuescanPatching;;
	e|E) printf "\n\nGoodbay!\n\n" && exit 0;;
esac
}

mainWork

#
##
### Input VueScan build number ##############################################################

echo -en ${WHITE} '\n\n'
read -p "Please input your VueScan build manually (supported builds are [$version_vuescan]): `echo $'\n> '`" v

#
##
#### Check VueScan if the build is supported ################################################

if [[ ! $version_vuescan = *"$v"* ]]; then
	echo -en ${LRED} '\nError: Version '$v' is not in support list: ['$version_vuescan']\n'
	echo -en ${RED} '\nGoodbay!\n'
	echo -en ${RESTORE}
	exit 1
fi

#
##
### Patching binary #########################################################################

function patch {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/$prog" &> /dev/null
	    shift 2
	done
}

echo -en ${CYAN} '\nStart patching...\n\n'
case $v in
    "9.6.44" )
	vs9644='
	0x07B6C2 \xEB 0x0A5600 \xC3 0x0B0CBE \x90 0x0B0CBF \x90 0x0B0CC0 \x90 0x0B0CC1 \x90 0x0B0CC2 \x90 0x0B0CC3 \x90
	0x0B0CD5 \x90 0x0B0CD6 \x90 0x0B0CD7 \x90 0x0B0CD8 \x90 0x0B0CD9 \x90 0x0B0CDA \x90 0x0B0CEC \x90 0x0B0CED \x90
	0x0B0CEE \x90 0x0B0CEF \x90 0x0B0CF0 \x90 0x0B0CF1 \x90 0x0B0D03 \x90 0x0B0D04 \x90 0x0B0D05 \x90 0x0B0D06 \x90
	0x0B0D07 \x90 0x0B0D08 \x90 0x0B0D1A \x90 0x0B0D1B \x90 0x0B0D1C \x90 0x0B0D1D \x90 0x0B0D1E \x90 0x0B0D1F \x90
	0x0B0D31 \x90 0x0B0D32 \x90 0x0B0D33 \x90 0x0B0D34 \x90 0x0B0D35 \x90 0x0B0D36 \x90 0x0B0D48 \x90 0x0B0D49 \x90
	0x0B0D4A \x90 0x0B0D4B \x90 0x0B0D4C \x90 0x0B0D4D \x90 0x0B0D5F \x90 0x0B0D60 \x90 0x0B0D61 \x90 0x0B0D62 \x90
	0x0B0D63 \x90 0x0B0D64 \x90 0x0B0D76 \x90 0x0B0D77 \x90 0x0B0D78 \x90 0x0B0D79 \x90 0x0B0D7A \x90 0x0B0D7B \x90
	0x0B0D8D \x90 0x0B0D8E \x90 0x0B0D8F \x90 0x0B0D90 \x90 0x0B0D91 \x90 0x0B0D92 \x90 0x0B0DA4 \x90 0x0B0DA5 \x90
	0x0B0DA6 \x90 0x0B0DA7 \x90 0x0B0DA8 \x90 0x0B0DA9 \x90 0x0B0DBB \x90 0x0B0DBC \x90 0x0B0DBD \x90 0x0B0DBE \x90
	0x0B0DBF \x90 0x0B0DC0 \x90 0x0B0EF4 \xEB'
	patch vuescan $vs9644
	;;

	* )
    echo -en ${RED} 'Error: Patching failed...\n'
    exit 1
    ;;
esac

echo -en ${LCYAN} 'The patching was done without errors.\n\n'
echo -en ${LGREEN} 'Congratulation!\n'
echo -en ${RESTORE} '\n'
#
exit 0
