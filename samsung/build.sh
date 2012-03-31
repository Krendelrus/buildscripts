#!/bin/bash

# Common defines (Arch-dependent)
case `uname -s` in
	Darwin)
		txtrst='\033[0m'  # Color off
		txtred='\033[0;31m' # Red
		txtgrn='\033[0;32m' # Green
		txtylw='\033[0;33m' # Yellow
		txtblu='\033[0;34m' # Blue
		THREADS=`sysctl -an hw.logicalcpu`
		;;
	*)
		txtrst='\e[0m'  # Color off
		txtred='\e[0;31m' # Red
		txtgrn='\e[0;32m' # Green
		txtylw='\e[0;33m' # Yellow
		txtblu='\e[0;34m' # Blue
		THREADS=`cat /proc/cpuinfo | grep processor | wc -l`
		;;
esac

echo -e "${txtgrn}##########################################"
echo -e "${txtgrn}#                                        #"
echo -e "${txtgrn}#    TEAMHACKSUNG ANDROID BUILDSCRIPT    #"
echo -e "${txtgrn}# visit us @ http://www.teamhacksung.org #"
echo -e "${txtgrn}#                                        #"
echo -e "${txtgrn}##########################################"
echo -e "\r\n ${txtrst}"

# Starting Timer
START=$(date +%s)
DEVICE="$1"
ADDITIONAL="$2"
#Moved to arch-dependent case above
#THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# Device specific settings
case "$DEVICE" in
	clean)
		make clean
		rm -rf ./out/target/product
		exit
		;;
	captivatemtd)
		board=aries
		lunch=aokp_captivatemtd-userdebug
		brunch=aokp_captivatemtd-userdebug
	;;
	fascinatemtd)
		board=aries
		lunch=aokp_fascinatemtd-userdebug
		brunch=aokp_fascinatemtd-userdebug
		;;
	galaxys2)
		board=smdk4210
		lunch=aokp_galaxys2-userdebug
		brunch=aokp_galaxys2-userdebug
		;;
	i777)
		board=smdk4210
		lunch=aokp_i777-userdebug
		brunch=aokp_i777-userdebug
		;;
	galaxysl)
		board=latona
		lunch=aokp_galaxysl-userdebug
		brunch=aokp_galaxysl-userdebug
		;;
	galaxynote)
		board=smdk4210
		lunch=aokp_galaxynote-userdebug
		brunch=aokp_galaxynote-userdebug
		;;
	galaxysmtd)
		board=aries
		lunch=aokp_galaxysmtd-userdebug
		brunch=aokp_galaxysmtd-userdebug
		;;
	galaxysbmtd)
		board=aries
		lunch=aokp_galaxysbmtd-userdebug
		brunch=aokp_galaxysbmtd-userdebug
		;;
	maguro)
		board=tuna
		lunch=aokp_maguro-userdebug
		brunch=aokp_maguro-userdebug
		;;
	vibrantmtd)
	    board=aries
	    lunch=aokp_vibrantmtd-userdebug
	    brunch=aokp_vibrantmtd-userdebug
	    ;;
	*)
		echo -e "${txtred}Usage: $0 DEVICE ADDITIONAL"
		echo -e "Example: ./build.sh galaxys2"
		echo -e "Example: ./build.sh galaxys2 kernel"
		echo -e "Supported Devices: captivatemtd, epic, fascinate, galaxys2, i777, galaxynote, galaxysmtd, galaxysbmtd, maguro, vibrantmtd${txtrst}"
		exit 2
		;;
esac

# Setting up Build Environment
echo -e "${txtgrn}Setting up Build Environment...${txtrst}"
. build/envsetup.sh
lunch ${lunch}

# Start the Build
case "$ADDITIONAL" in
	kernel)
		echo -e "${txtgrn}Building Kernel...${txtrst}"
		cd kernel/samsung/${board}
		./build.sh "$DEVICE"
		cd ../../..
		echo -e "${txtgrn}Building Android...${txtrst}"
		brunch ${brunch}
		;;
	*)
		echo -e "${txtgrn}Building Android...${txtrst}"
		brunch ${brunch}
		;;
esac

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
