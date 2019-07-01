#!/bin/bash
#-----------------------------------------------------------------------------------------------------------#
# Pre-cloning/Post-cloning Utility Script for Oracle E-Business Suite 12.1.x                                #
# This script is licenced under GPLv2 ; you can get your copy from http://www.gnu.org/licenses/gpl-2.0.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in                                                                      #
# This script requires 'dialog' package installed in system. To check # rpm -qa  | grep dialog              #
# * IMPORTANT: Set BASE, SID, HOST  before running script.                                                  #
#-----------------------------------------------------------------------------------------------------------#

# -- ENV:
    source ebs-121x-prcpoc.env

# -- COLORS:
	export RESET="\e[0m"
	export GRAY="\e[100m"

# -- PROCESSES:
    export LISTN="$(ps -ef |  grep tns | grep 11.2.0 | wc -l)"
    export DB="$(ps -ef | grep ora_ | grep $SID | wc -l)"
    export APP="$(ps -ef | grep FND | wc -l)"

# -- DATE:
    export DATE=$(date +%F_%H-%M-%S)

# -- CLONE PREFIX:
    export CLONE="clone_backup"

# -- FUNC:

preclone()
{
echo ""
}

postclone()
{
echo ""
}

autoconfig()
{
echo ""
}

# -- BACKUP FUNCTION:
backup()
{

# -- SOURCE LOCATION:
sourceloc()
{
SRC=$(dialog --clear --backtitle "PRE-CLONING/POST-CLONING UTILITY FOR EBS 12.1.x " \
            --title "Source location" --stdout --fselect ~ 8 40)
}

# -- DESTINATION LOCATION:
destinationloc()
{
DEST=$(dialog --clear --backtitle "PRE-CLONING/POST-CLONING UTILITY FOR EBS 12.1.x " \
            --title "Destination location" --stdout --fselect ~ 8 40)
}

# -- START BACKUP PROCESS:
startbackup()
{
    tar -cvzf $DEST/$CLONE_$DATE.tar.gz $SRC/ && rsync -avzh --progress $DEST/$CLONE_$DATE.tar.gz $SRC/

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}


# -- BACKUP MAIN MENU:
menu=(Start-Backup  "Start backup process."
      Exit          "Exit to shell.")

while true ; do
    cli=$(dialog    --clear \
                    --backtitle "PRE-CLONING/POST-CLONING UTILITY FOR EBS 12.1.x" \
                    --title "Backup" \
                    --menu "               NOTE: USE ARROW KEYS TO NAVIGATE" \
                    15 68 2 "${menu[@]}" 2>&1 > /dev/tty)

    clear
    case $cli in
            Start-Backup) sourceloc && destinationloc && startbackup ;;
	        Exit) echo "Bye"; break;;
    esac
done

}

# -- MAIN MENU:

mainmenu=(Preclone  "Prepare DB & APPS for cloning."
         Postclone  "Prepare DB & APPS after cloning."
         Autoconfig "Auto-configure DB & APPS."
         Backup     "Take backup for pre-clone setup."
         Exit       "Exit to the shell")

while true ; do
    cli=$(dialog    --clear \
                    --backtitle "PRE-CLONING/POST-CLONING UTILITY FOR EBS 12.1.x" \
                    --title "[ M A I N - M E N U ]" \
                    --menu "               NOTE: USE ARROW KEYS TO NAVIGATE" \
                    15 68 5 "${mainmenu[@]}" 2>&1 > /dev/tty)

    clear
    case $cli in
            Preclone) preclone;;
            Postclone) postclone;;
            Autoconfig) autoconfig;;
            Backup) backup ;;
	        Exit) echo "Bye"; break;;
    esac
done
