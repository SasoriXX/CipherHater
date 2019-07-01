#!/bin/bash
#

#############################################################################################
#
# Brief: Script for patching SoftMaker Office (rev 965.0629) x64 Linux x86_64
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

version_SoftMaker='2018'

#
##
### Start menu ##############################################################################

echo -en ${LYELLOW} "\nThis script supports only: \n\n \
	${GREEN}Platform: ${WHITE} Linux x86_64\n\n \
	${GREEN}SoftMaker Office (rev 965.0629) x64: ${LMAGENTA} $version_SoftMaker\n\n"

echo -en ${RESTORE}

#
##
### Function for SoftMaker ##################################################################

function SoftMakerPatching {
echo -en ${YELLOW} '\nChecking SoftMaker Office path ...\n'

if [[ -f './textmaker' ]]; then 
	p='.'
else
	echo -en ${WHITE} 
	read -r -p "Please input SoftMaker Office installed path (the directory contains SoftMaker Office files): \
			    `echo $'\n> '`" p

	if [[ ! -d "$p" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a directory!\n\n'
	    echo -en ${RED} 'Goodbay!\n\n'
	    echo -en ${RESTORE}
	    exit 11
	fi

	if [[ ! -f "$p/textmaker" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a SoftMaker Office installed path!\n\n'
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
read -p 'Backup SoftMaker Office binary? [y/n]: ' bt
    if [ -n $bt ] && [ $bt != "n" ]; then
	# Backup SoftMaker
	echo -en ${GREEN} '\nRunning backup: copy all binary files to "*.orig" ...\n'
	cp -i "$p/textmaker" "$p/textmaker.orig"
	cp -i "$p/planmaker" "$p/planmaker.orig"
	cp -i "$p/presentations" "$p/presentations.orig"
	echo
    fi
echo -en ${RESTORE}
}


#
##
### Function select which program to patch ##################################################

function mainWork {
echo -en ${WHITE}
read -n1 -p "Pick a letter to run patching: S - SoftMaker Office, or E - Exit script." runPatching

case $runPatching in
	s|S) printf "\n\nStart patching SoftMaker Office 2018.\n" && SoftMakerPatching;;
	e|E) printf "\n\nGoodbay!\n\n" && exit 0;;
esac
}

mainWork

#
##
### Input SoftMaker build number ############################################################

echo -en ${WHITE} '\n\n'
read -p "Please input your SoftMaker build manually (supported builds are [$version_SoftMaker]): `echo $'\n> '`" v

#
##
#### Check SoftMaker if the build is supported ##############################################

if [[ ! $version_SoftMaker = *"$v"* ]]; then
	echo -en ${LRED} '\nError: Version '$v' is not in support list: ['$version_SoftMaker']\n'
	echo -en ${RED} '\nGoodbay!\n'
	echo -en ${RESTORE}
	exit 1
fi

#
##
### Patching binary #########################################################################

function patch_textmaker {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/$prog" &> /dev/null
	    shift 2
	done
}

function patch_planmaker {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/$prog" &> /dev/null
	    shift 2
	done
}

function patch_presentations {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/$prog" &> /dev/null
	    shift 2
	done
}

echo -en ${CYAN} '\nStart patching SoftMaker Office files...\n\n'
case $v in
    "2018" )
	textmaker='
	0x68BD04 \x90 0x68BD05 \x90 0x68BD71 \xEB 0x68BE80 \xE9 0x68BE81 \xB5 0x68BE82 \x00 0x68BE85 \x90 0xACEDFF \xC3
	0xDA3671 \xC3 0xDA3CA0 \xC3 0xDA3DF0 \xC3'
	patch_textmaker textmaker $textmaker
	;;

	* )
    echo -en ${RED} 'Error: Patching textmaker failed...\n'
    exit 1
    ;;
esac

case $v in
    "2018" )
	planmaker='
	0x4C704A \x90 0x4C704B \x90 0x4C70B7 \xEB 0x4C71C6 \xE9 0x4C71C7 \xB5 0x4C71C8 \x00 0x4C71CB \x90 0x856A2D \xC3
	0xB27799 \xC3 0xB27DC8 \xC3 0xB27F18 \xC3'
	patch_planmaker planmaker $planmaker
	;;

	* )
    echo -en ${RED} 'Error: Patching planmaker failed...\n'
    exit 1
    ;;
esac

case $v in
    "2018" )
	presentations='
	0x34801E \x90 0x34801F \x90 0x34808B \xEB 0x34819A \xE9 0x34819B \xB5 0x34819C \x00 0x34819F \x90 0x6A64F1 \xC3
	0x97BA4E \xC3 0x97C07D \xC3 0x97C1CD \xC3'
	patch_presentations presentations $presentations
	;;

	* )
    echo -en ${RED} 'Error: Patching presentations failed...\n'
    exit 1
    ;;
esac

echo -en ${LCYAN} 'The patching was done without errors.\n\n'
echo -en ${LGREEN} 'Congratulation!\n'
echo -en ${RESTORE} '\n'
#
exit 0
