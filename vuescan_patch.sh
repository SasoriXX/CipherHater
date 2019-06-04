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

version_vuescan='9.6.41'

#
##
### Start menu ##############################################################################

echo -en ${LYELLOW} "\nThis script supports only: \n\n \
	${GREEN}Platform: ${WHITE} Linux x86_64\n\n \
	${GREEN}VueScan 9 x64 (v9.6.41): ${LMAGENTA} $version_vuescan\n\n"

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
    "9.6.41" )
	vs9641='
	0x07B6D2 \xEB 0x0B0D9E \x90 0x0B0D9F \x90 0x0B0DA0 \x90 0x0B0DA1 \x90 0x0B0DA2 \x90 0x0B0DA3 \x90 0x0B0DB5 \x90
	0x0B0DB6 \x90 0x0B0DB7 \x90 0x0B0DB8 \x90 0x0B0DB9 \x90 0x0B0DBA \x90 0x0B0DCC \x90 0x0B0DCD \x90 0x0B0DCE \x90
	0x0B0DCF \x90 0x0B0DD0 \x90 0x0B0DD1 \x90 0x0B0DE3 \x90 0x0B0DE4 \x90 0x0B0DE5 \x90 0x0B0DE6 \x90 0x0B0DE7 \x90
	0x0B0DE8 \x90 0x0B0DFA \x90 0x0B0DFB \x90 0x0B0DFC \x90 0x0B0DFD \x90 0x0B0DFE \x90 0x0B0DFF \x90 0x0B0E11 \x90
	0x0B0E12 \x90 0x0B0E13 \x90 0x0B0E14 \x90 0x0B0E15 \x90 0x0B0E16 \x90 0x0B0E28 \x90 0x0B0E29 \x90 0x0B0E2A \x90
	0x0B0E2B \x90 0x0B0E2C \x90 0x0B0E2D \x90 0x0B0E3F \x90 0x0B0E40 \x90 0x0B0E41 \x90 0x0B0E42 \x90 0x0B0E43 \x90
	0x0B0E44 \x90 0x0B0E56 \x90 0x0B0E57 \x90 0x0B0E58 \x90 0x0B0E59 \x90 0x0B0E5A \x90 0x0B0E5B \x90 0x0B0E6D \x90
	0x0B0E6E \x90 0x0B0E6F \x90 0x0B0E70 \x90 0x0B0E71 \x90 0x0B0E72 \x90 0x0B0E84 \x90 0x0B0E85 \x90 0x0B0E86 \x90
	0x0B0E87 \x90 0x0B0E88 \x90 0x0B0E89 \x90 0x0B0E9B \x90 0x0B0E9C \x90 0x0B0E9D \x90 0x0B0E9E \x90 0x0B0E9F \x90
	0x0B0EA0 \x90 0x0B0FD4 \xEB'
	patch vuescan $vs9641
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
