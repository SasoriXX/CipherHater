#!/bin/bash
#

#############################################################################################
#
# Brief: Script for patching QCam (Version 3.22.1) x64 Linux x86_64
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

version_QCam='3.22.1'

#
##
### Start menu ##############################################################################

echo -en ${LYELLOW} "\nThis script supports only: \n\n \
	${GREEN}Platform: ${WHITE} Linux x86_64\n\n \
	${GREEN}QCam (Version 3.22.1) x64: ${LMAGENTA} $version_QCam\n\n"

echo -en ${RESTORE}

#
##
### Function for QCam #######################################################################

function qcamPatching {
echo -en ${YELLOW} '\nChecking QCam path ...\n'

if [[ -f './qcad-bin' ]]; then 
	p='.'
else
	echo -en ${WHITE} 
	read -r -p "Please input QCam installed path (the directory contains QCam files): \
			    `echo $'\n> '`" p

	if [[ ! -d "$p" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a directory!\n\n'
	    echo -en ${RED} 'Goodbay!\n\n'
	    echo -en ${RESTORE}
	    exit 11
	fi

	if [[ ! -f "$p/qcad-bin" ]]; then
	    echo -en ${LRED} '\nError: '$p' Is not a QCam installed path!\n\n'
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
read -p 'Backup QCam files? [y/n]: ' bt
    if [ -n $bt ] && [ $bt != "n" ]; then
	# Backup QCam
	echo -en ${GREEN} '\nRunning backup: copy QCam files to "*.orig" ...\n'
	cp -i "$p/plugins/libqcaddwg.so" "$p/plugins/libqcaddwg.so.orig"
	cp -i "$p/plugins/libqcadpolygon.so" "$p/plugins/libqcadpolygon.so.orig"
	cp -i "$p/plugins/libqcadproscripts.so" "$p/plugins/libqcadproscripts.so.orig"
	cp -i "$p/plugins/libqcadspatialindexpro.so" "$p/plugins/libqcadspatialindexpro.so.orig"
	cp -i "$p/plugins/libqcadtriangulation.so" "$p/plugins/libqcadtriangulation.so.orig"
	cp -i "$p/plugins/libqcadcsg.so" "$p/plugins/libqcadcsg.so.orig"
	cp -i "$p/plugins/libqcadgles3d.so" "$p/plugins/libqcadgles3d.so.orig"
	cp -i "$p/plugins/libqcadcamscripts.so" "$p/plugins/libqcadcamscripts.so.orig"
	echo
    fi
echo -en ${RESTORE}
}


#
##
### Function select which program to patch ##################################################

function mainWork {
echo -en ${WHITE}
read -n1 -p "Pick a letter to run patching: Q - QCam, or E - Exit script." runPatching

case $runPatching in
	q|Q) printf "\n\nStart patching QCam Version 3.22.1.\n" && qcamPatching;;
	e|E) printf "\n\nGoodbay!\n\n" && exit 0;;
esac
}

mainWork

#
##
### Input QCam build number #################################################################

echo -en ${WHITE} '\n\n'
read -p "Please input your QCam build manually (supported builds are [$version_QCam]): `echo $'\n> '`" v

#
##
#### Check QCam if the build is supported ###################################################

if [[ ! $version_QCam = *"$v"* ]]; then
	echo -en ${LRED} '\nError: Version '$v' is not in support list: ['$version_QCam']\n'
	echo -en ${RED} '\nGoodbay!\n'
	echo -en ${RESTORE}
	exit 1
fi

#
##
### Patching files ##########################################################################

function patch_libqcaddwg {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadpolygon {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadproscripts {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadspatialindexpro {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadtriangulation {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadcsg {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadgles3d {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}

function patch_libqcadcamscripts {
    prog=$1
    shift
    until [ $# -eq 0 ]
	do
	    printf $2 | dd seek=$(($1)) conv=notrunc bs=1 of="$p/plugins/$prog" &> /dev/null
	    shift 2
	done
}


echo -en ${CYAN} '\nStart patching QCam files...\n\n'
case $v in
    "3.22.1" )
	libqcaddwg='
	0x16BA2E5 \x90 0x16BA2E6 \x90 0x16BA2E7 \x90 0x16BA2E8 \x90 0x16BA2E9 \x90'
	patch_libqcaddwg libqcaddwg.so $libqcaddwg
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcaddwg.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadpolygon='
	0x036798 \x90 0x036799 \x90 0x03679A \x90 0x03679B \x90 0x03679C \x90'
	patch_libqcadpolygon libqcadpolygon.so $libqcadpolygon
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadpolygon.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadproscripts='
	0x006152 \x90 0x006153 \x90 0x006154 \x90 0x006155 \x90 0x006156 \x90'
	patch_libqcadproscripts libqcadproscripts.so $libqcadproscripts
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadproscripts.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadspatialindexpro='
	0x01C508 \x90 0x01C509 \x90 0x01C50A \x90 0x01C50B \x90 0x01C50C \x90'
	patch_libqcadspatialindexpro libqcadspatialindexpro.so $libqcadspatialindexpro
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadspatialindexpro.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadtriangulation='
	0x014898 \x90 0x014899 \x90 0x01489A \x90 0x01489B \x90 0x01489C \x90'
	patch_libqcadtriangulation libqcadtriangulation.so $libqcadtriangulation
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadtriangulation.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadcsg='
	0x015AE8 \x90 0x015AE9 \x90 0x015AEA \x90 0x015AEB \x90 0x015AEC \x90'
	patch_libqcadcsg libqcadcsg.so $libqcadcsg
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadcsg.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadgles3d='
	0x022AE8 \x90 0x022AE9 \x90 0x022AEA \x90 0x022AEB \x90 0x022AEC \x90'
	patch_libqcadgles3d libqcadgles3d.so $libqcadgles3d
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadgles3d.so failed...\n'
    exit 1
    ;;
esac

case $v in
    "3.22.1" )
	libqcadcamscripts='
	0x005F0A \x90 0x005F0B \x90 0x005F0C \x90 0x005F0D \x90 0x005F0E \x90'
	patch_libqcadcamscripts libqcadcamscripts.so $libqcadcamscripts
	;;

	* )
    echo -en ${RED} 'Error: Patching libqcadcamscripts.so failed...\n'
    exit 1
    ;;
esac


echo -en ${LCYAN} 'The patching was done without errors.\n\n'
echo -en ${LGREEN} 'Congratulation!\n'
echo -en ${RESTORE} '\n'
#
exit 0
