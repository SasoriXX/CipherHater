#!/bin/bash
#

#############################################################################################
#
# Brief: Script for patching SoftMaker (rev 962.0418) x64 Linux x86_64
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
	${GREEN}SoftMaker Office (rev 962.0418) x64: ${LMAGENTA} $version_SoftMaker\n\n"

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
	0x688350 \x90 0x688351 \x90 0x6883BD \xEB 0x6884CC \xE9 0x6884CD \xB5 0x6884CE \x00 0x6884D1 \x90 0xD9E71D \xC3
	0xD9ED4C \xC3 0xD9EE9C \xC3'
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
	0x4C3436 \x90 0x4C3437 \x90 0x4C34A3 \xEB 0x4C35B2 \xE9 0x4C35B3 \xB5 0x4C35B4 \x00 0x4C35B7 \x90 0xB1E63D \xC3
	0xB1EC6C \xC3 0xB1EDBC \xC3'
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
	0x345C88 \x90 0x345C89 \x90 0x345CF5 \xEB 0x345E04 \xE9 0x345E05 \xB5 0x345E06 \x00 0x345E09 \x90 0x978254 \xC3
	0x978883 \xC3 0x9789D3 \xC3'
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
