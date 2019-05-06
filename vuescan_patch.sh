#!/bin/bash
#

#############################################################################################
#
# Brief: Script for patching VueScan 9 x64 (9.6.38/9.6.39) Linux x86_64
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

version_vuescan='9.6.38 9.6.39'

#
##
### Start menu ##############################################################################

echo -en ${LYELLOW} "\nThis script supports only: \n\n \
	${GREEN}Platform: ${WHITE} Linux x86_64\n\n \
	${GREEN}VueScan 9 x64 (v9.6.38/v9.6.39): ${LMAGENTA} $version_vuescan\n\n"

echo -en ${RESTORE}

#
##
### Function for VueScan 9 #############################################################

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
### Input VueScan build number ###############################################################

echo -en ${WHITE} '\n\n'
read -p "Please input your VueScan build manually (supported builds are [$version_vuescan]): `echo $'\n> '`" v

#
##
#### Check VueScan if the build is supported #################################################

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
    "9.6.38" )
	vs9638='
	0x03D78B \x01 0x04B7D2 \x90 0x04B7D3 \x90 0x04B7D4 \x90 0x04B7D5 \x90 0x04B7D6 \x90 0x04B7D7 \x90 0x04B803 \x00
	0x04D42E \x90 0x04D42F \x90 0x04D430 \x90 0x04D431 \x90 0x04D432 \x90 0x04D433 \x90 0x04D997 \x90 0x04D998 \x90
	0x04D999 \x90 0x04D99A \x90 0x04D99B \x90 0x04D99C \x90 0x04D99D \x90 0x04D99E \x90 0x04D99F \x90 0x04D9A0 \x90
	0x04D9A1 \x90 0x04D9A2 \x90 0x04D9A3 \x90 0x04D9A4 \x90 0x04D9A5 \x90 0x04D9A6 \x90 0x04D9A7 \x90 0x04D9A8 \x90
	0x04D9A9 \x90 0x04E247 \x90 0x04E248 \x90 0x04E249 \x90 0x04E24A \x90 0x04E24B \x90 0x04E24C \x90 0x072EE6 \x90
	0x072EE7 \x90 0x072EE8 \x90 0x072EE9 \x90 0x072EEA \x90 0x072EEB \x90 0x076546 \xE9 0x076547 \xCB 0x076548 \x07
	0x076549 \x00 0x076D18 \xE9 0x076D19 \x62 0x076D1A \xF8 0x076D1B \xFF 0x0775F0 \x90 0x0775F1 \x90 0x0775FB \x90
	0x0775FC \x90 0x077605 \xEB 0x07760E \x90 0x07760F \x90 0x07761E \xEB 0x07765A \xEB 0x077683 \x90 0x077684 \x90
	0x07768E \x90 0x07768F \x90 0x077698 \xE9 0x077699 \x9E 0x07769A \x00 0x077735 \x90 0x077736 \x90 0x077737 \x90
	0x077738 \x90 0x077739 \x90 0x07773A \x90 0x08859A \x90 0x08859B \x90 0x08859C \x90 0x08859D \x90 0x08859E \x90
	0x08859F \x90 0x08B70F \x90 0x08B710 \x90 0x08B711 \x90 0x08B712 \x90 0x08B713 \x90 0x08B714 \x90 0x08B715 \x90
	0x08B716 \x90 0x08B717 \x90 0x08B718 \x90 0x08B71A \x90 0x08B71B \x90 0x08B71C \x90 0x08B71D \x90 0x08B71E \x90
	0x08B71F \x90 0x08B720 \x90 0x08B721 \x90 0x08B722 \x90 0x08B723 \x90 0x08B724 \x90 0x08B725 \x90 0x08B726 \x90
	0x08B727 \x90 0x08B728 \x90 0x08B729 \x90 0x08B72A \x90 0x08B72B \x90 0x08B72C \x90 0x08B72D \x90 0x08B72E \x90
	0x08B72F \x90 0x08B730 \x90 0x08B731 \x90 0x08B732 \x90 0x08B733 \x90 0x08B734 \x90 0x08B735 \x90 0x08B736 \x90
	0x08B737 \x90 0x08BA56 \xE9 0x08BA57 \xB2 0x08BA58 \xFC 0x08BA59 \xFF 0x08BA5E \x90 0x08BA5F \x90 0x08BA60 \x90
	0x08BA61 \x90 0x08BA62 \x90 0x08BA63 \x90 0x08BB9C \x90 0x08BB9D \x90 0x08BBB6 \x01 0x08BD66 \x90 0x08BD67 \x90
	0x08BD68 \x90 0x08BD69 \x90 0x08BD6A \x90 0x08BD6B \x90 0x08BD7F \x90 0x08BD80 \x90 0x08BD81 \x90 0x08BD82 \x90
	0x08BD83 \x90 0x08BD84 \x90 0x096625 \xE9 0x096626 \xAE 0x096627 \x0B 0x096628 \x00 0x09E300 \xC3 0x09E3E0 \xC3
	0x09E3E1 \x90 0x09E3E2 \x90 0x09E3E3 \x90 0x09E3E4 \x90 0x09E3F0 \xC3 0x09E402 \xEB 0x09E416 \x90 0x09E417 \x90
	0x09E434 \x90 0x09E435 \x90 0x09E43B \x90 0x09E43C \x90 0x09E45F \x90 0x09E460 \x90 0x09E468 \x90 0x09E469 \x90
	0x09E46D \x90 0x09E46E \x90 0x09E46F \x90 0x09E470 \x90 0x09E471 \x90 0x09E472 \x90 0x09E476 \x90 0x09E477 \x90
	0x09E478 \x90 0x09E479 \x90 0x09E47A \x90 0x09E47B \x90 0x09E480 \x90 0x09E481 \x90 0x09E482 \x90 0x09E483 \x90
	0x09E484 \x90 0x09E485 \x90 0x09E489 \x90 0x09E48A \x90 0x09E491 \x90 0x09E492 \x90 0x09E493 \x90 0x09E494 \x90
	0x09E495 \x90 0x09E496 \x90 0x09E4B7 \xEB 0x09E4DF \x90 0x09E4E0 \x90 0x09E630 \xC3 0x09E631 \x90 0x09E632 \x90
	0x09E633 \x90 0x09E748 \x90 0x09E749 \x90 0x09EFE2 \xEB 0x0A1940 \xC3 0x0A1941 \x90 0x0A1942 \x90 0x0A1943 \x90
	0x0A1944 \x90'
	patch vuescan $vs9638
	;;

    "9.6.39" )
	vs9639='
	0x03D5FB \x01 0x04B632 \x90 0x04B633 \x90 0x04B634 \x90 0x04B635 \x90 0x04B636 \x90 0x04B637 \x90 0x04B663 \x00
	0x04D7F7 \x90 0x04D7F8 \x90 0x04D7F9 \x90 0x04D7FA \x90 0x04D7FB \x90 0x04D7FC \x90 0x04D7FD \x90 0x04D7FE \x90
	0x04D7FF \x90 0x04D800 \x90 0x04D801 \x90 0x04D802 \x90 0x04D803 \x90 0x04D804 \x90 0x04D805 \x90 0x04D806 \x90
	0x04D807 \x90 0x04D808 \x90 0x04D809 \x90 0x04E0A7 \x90 0x04E0A8 \x90 0x04E0A9 \x90 0x04E0AA \x90 0x04E0AB \x90
	0x04E0AC \x90 0x072DC6 \x90 0x072DC7 \x90 0x072DC8 \x90 0x072DC9 \x90 0x072DCA \x90 0x072DCB \x90 0x076446 \xE9
	0x076447 \xCB 0x076448 \x07 0x076449 \x00 0x07644B \x90 0x076C18 \xE9 0x076C19 \x62 0x076C1A \xF8 0x076C1B \xFF
	0x076C1D \x90 0x0774F0 \x90 0x0774F1 \x90 0x0774FB \x90 0x0774FC \x90 0x077505 \xEB 0x07750E \x90 0x07750F \x90
	0x07751E \xEB 0x07755A \xEB 0x077583 \x90 0x077584 \x90 0x07758E \x90 0x07758F \x90 0x077598 \xE9 0x077599 \x9E
	0x07759A \x00 0x07759D \x90 0x077635 \x90 0x077636 \x90 0x077637 \x90 0x077638 \x90 0x077639 \x90 0x07763A \x90
	0x08858A \x90 0x08858B \x90 0x08858C \x90 0x08858D \x90 0x08858E \x90 0x08858F \x90 0x08B6FF \x90 0x08B700 \x90
	0x08B701 \x90 0x08B702 \x90 0x08B703 \x90 0x08B704 \x90 0x08B705 \x90 0x08B706 \x90 0x08B707 \x90 0x08B708 \x90
	0x08B70A \x90 0x08B70B \x90 0x08B70C \x90 0x08B70D \x90 0x08B70E \x90 0x08B70F \x90 0x08B710 \x90 0x08B711 \x90
	0x08B712 \x90 0x08B713 \x90 0x08B714 \x90 0x08B715 \x90 0x08B716 \x90 0x08B717 \x90 0x08B718 \x90 0x08B719 \x90
	0x08B71A \x90 0x08B71B \x90 0x08B71C \x90 0x08B71D \x90 0x08B71E \x90 0x08B71F \x90 0x08B720 \x90 0x08B721 \x90
	0x08B722 \x90 0x08B723 \x90 0x08B724 \x90 0x08B725 \x90 0x08B726 \x90 0x08B727 \x90 0x08BA46 \xE9 0x08BA47 \xB2
	0x08BA48 \xFC 0x08BA49 \xFF 0x08BA4B \x90 0x08BA4E \x90 0x08BA4F \x90 0x08BA50 \x90 0x08BA51 \x90 0x08BA52 \x90
	0x08BA53 \x90 0x08BB8C \x90 0x08BB8D \x90 0x08BBA6 \x01 0x08BD56 \x90 0x08BD57 \x90 0x08BD58 \x90 0x08BD59 \x90
	0x08BD5A \x90 0x08BD5B \x90 0x08BD6F \x90 0x08BD70 \x90 0x08BD71 \x90 0x08BD72 \x90 0x08BD73 \x90 0x08BD74 \x90
	0x096615 \xE9 0x096616 \xAE 0x096617 \x0B 0x096618 \x00 0x09661A \x90 0x09E2F0 \xC3 0x09E3D0 \xC3 0x09E3D1 \x90
	0x09E3D2 \x90 0x09E3D3 \x90 0x09E3D4 \x90 0x09E3E0 \xC3 0x09E3F2 \xEB 0x09E406 \x90 0x09E407 \x90 0x09E424 \x90
	0x09E425 \x90 0x09E42B \x90 0x09E42C \x90 0x09E44F \x90 0x09E450 \x90 0x09E458 \x90 0x09E459 \x90 0x09E45D \x90
	0x09E45E \x90 0x09E45F \x90 0x09E460 \x90 0x09E461 \x90 0x09E462 \x90 0x09E466 \x90 0x09E467 \x90 0x09E468 \x90
	0x09E469 \x90 0x09E46A \x90 0x09E46B \x90 0x09E470 \x90 0x09E471 \x90 0x09E472 \x90 0x09E473 \x90 0x09E474 \x90
	0x09E475 \x90 0x09E479 \x90 0x09E47A \x90 0x09E481 \x90 0x09E482 \x90 0x09E483 \x90 0x09E484 \x90 0x09E485 \x90
	0x09E486 \x90 0x09E4A7 \xEB 0x09E4CF \x90 0x09E4D0 \x90 0x09E620 \xC3 0x09E621 \x90 0x09E622 \x90 0x09E623 \x90
	0x09E738 \x90 0x09E739 \x90 0x09EFD2 \xEB 0x0A1930 \xC3 0x0A1931 \x90 0x0A1932 \x90 0x0A1933 \x90 0x0A1934 \x90'
	patch vuescan $vs9639
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
