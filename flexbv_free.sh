#!/bin/bash
#

#############################################################################################
#
# Brief: Script for patching FlexBV x64 R883/R985 Linux x86_64 (http://pldaniels.com)
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

version_flexbv='R883 R985'

#
##
### Start menu ##############################################################################

echo -en ${LYELLOW} "\nThis script supports only: \n\n \
	${GREEN}Platform: ${WHITE} Linux x86_64\n\n \
	${GREEN}FlexBV x64 R883/R985: ${LMAGENTA} $version_flexbv\n\n"

echo -en ${RESTORE}

#
##
### Function for FlexBV #####################################################################

function flexbvPatching {
echo -en ${YELLOW} '\nChecking FlexBV path ...\n'

if [[ -f './flexbv' ]]; then 
	p='.'
else
	echo -en ${WHITE} 
	read -r -p "Please input FlexBV installed path (the directory contains flexbv): \
			    `echo $'\n> '`" p

	if [[ ! -d "$p" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a directory!\n\n'
	    echo -en ${RED} 'Goodbay!\n\n'
	    echo -en ${RESTORE}
	    exit 11
	fi

	if [[ ! -f "$p/flexbv" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a FlexBV installed path!\n\n'
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
read -p 'Backup FlexBV binary? [y/n]: ' bt
    if [ -n $bt ] && [ $bt != "n" ]; then
	# Backup FlexBV
	echo -en ${GREEN} '\nRunning backup: copy "flexbv" to "flexbv.orig" ...\n'
	cp -i "$p/flexbv" "$p/flexbv.orig"
	echo
    fi
echo -en ${RESTORE}
}


#
##
### Function select which program to patch ##################################################

function mainWork {
echo -en ${WHITE}
read -n1 -p "Pick a letter to run patching: F - FlexBV, or E - Exit script." runPatching

case $runPatching in
	f|F) printf "\n\nStart patching FlexBV x64.\n" && flexbvPatching;;
	e|E) printf "\n\nGoodbay!\n\n" && exit 0;;
esac
}

mainWork

#
##
### Input FlexBV build number ###############################################################

echo -en ${WHITE} '\n\n'
read -p "Please input your FlexBV build manually (supported builds are [$version_flexbv]): `echo $'\n> '`" v

#
##
#### Check FlexBV if the build is supported #################################################

if [[ ! $version_flexbv = *"$v"* ]]; then
	echo -en ${LRED} '\nError: Version '$v' is not in support list: ['$version_flexbv']\n'
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
    "R883" )
	vs883='
	0x090A04 \xC3 0x090A14 \x1F 0x090A15 \xFF 0x090A16 \xFF 0x0A2B9A \xC3 0x0A2D00 \x90 0x0A2D01 \x90 0x0B36F1 \x90
	0x0B36F2 \x90 0x0B36F3 \x90 0x0B36F4 \x90 0x0B36F5 \x90 0x0B36F6 \x90 0x0B38F7 \x90 0x0B38F8 \x90 0x0B54FF \xEB'
	patch flexbv $vs883
	;;

    "R985" )
	vs985='
	0x03A120 \x90 0x03A121 \x90 0x03A122 \x90 0x03A123 \x90 0x03A124 \x90 0x03A125 \x90 0x03A126 \x90 0x052180 \xC3
	0x052181 \x90 0x052252 \x90 0x052253 \x90 0x052254 \x90 0x052255 \x90 0x052256 \x90 0x052257 \x90 0x05F056 \x90
	0x05F057 \x90 0x05F058 \x90 0x05F059 \x90 0x05F05A \x90 0x05F05B \x90 0x05F578 \xE9 0x05F579 \x73 0x05F57A \x0F
	0x05F57B \x00 0x05F57D \x90 0x060935 \x90 0x060936 \x90 0x060937 \x90 0x060938 \x90 0x060939 \x90 0x06093A \x90
	0x0D6451 \xE9 0x0D6452 \xE4 0x0D6453 \xE6 0x0D6454 \xFF 0x0D6456 \x90'
	patch flexbv $vs985
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
