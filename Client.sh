#!/bin/bash

#
## Project : GitProjectManagementTool
##
## Creator : Nathan Hautbois
##
## Contributors : 
##
## Date : 05/09/2017
#

#
## Version 0.1
#

## Dev Tool

# Colors

NO_COLOR="\033[0m"
COLOR_PURPLE="\033[35m"
COLOR_BLUE="\033[34m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"

Cpurple() { echo -e "$COLOR_PURPLE$@$NO_COLOR"; }
Cblue() { echo -e "$COLOR_BLUE$@$NO_COLOR"; }
Cgreen() { echo -e "$COLOR_GREEN$@$NO_COLOR"; }
Cred() { echo -e "$COLOR_RED$@$NO_COLOR"; }

# Debug

DEBUG=1
DebugTxt()
{
    if [ $DEBUG -eq 0 ] ; then
	Cpurple "$@"
    fi
}

VERBOSE=0
VerboseTxt()
{
    if [ $VERBOSE -eq 0 ] ; then
	echo "$@"
    fi
}

run()
{
    if [ $VERBOSE -eq 0 ] ; then
	v=$(exec 2>&1 && set -x && set -- "$@")
	VerboseTxt "#${v#*--}"
	Cblue "#${v#*--}"
	"$@"
    else
	"$@" >/dev/null 2>&1
    fi
}

## Globals Var

# Flags
CREATE_REPO=1
CLONE_REPO=1
DELETE_REPO=1
LIST_REPO=1
CONFIGURE_PG=1

# Content
CONF_FILE=~/.git-project-manager.conf
CONF_FILE_BCP=~/.git-project-manager.conf.bcp
TARGET_REPOSITORY=""

## Program

# Helper
Helper()
{
    echo "halp"
}

# Options Functions

ConfigureProgram()
{
    if [ -f $CONF_FILE ] ; then
	echo "Configuration file already exist, choose an option by entering a number: "
	echo "1 - Overwrite with backup"
	echo "2 - Overwrite without backup"
	echo "3 - Cancel"
	local w_done=1
	while [ $w_done -eq 1 ] ;
	do
	    read rep
	    case "$rep" in
		"1") w_done=0
		     ;;
		"2") mv $CONF_FILE $CONF_FILE_BCP
		     w_done=0
		     ;;
		"3") exit 0
		     w_done=0
		     ;;
		*) echo "Please use 1, 2 or 3."
		   ;;
	    esac
	done
    fi

    Cgreen "Please enter your git server ip X.X.X.X : \c"
    read conf_ip
    echo "SERVER_IP=$conf_ip" > $CONF_FILE
    
    Cgreen "Please enter your git server username : \c"
    read conf_user
    echo "SERVER_USER=$conf_user" >> $CONF_FILE
    
}

CreateRepository()
{
    DebugTxt "CreateRepository with $TARGET_REPOSITORY"
    ssh $SERVER_USER@$SERVER_IP "./Server.sh --create-repository $TARGET_REPOSITORY"
}

DeleteRepository()
{
    DebugTxt "DeleteRepository with $TARGET_REPOSITORY"
    ssh $SERVER_USER@$SERVER_IP "./Server.sh --delete-repository $TARGET_REPOSITORY"
}

CloneRepository()
{
    DebugTxt "CloneRepository with $TARGET_REPOSITORY"
    git clone $SERVER_USER@$SERVER_IP:~/repositories/$TARGET_REPOSITORY.git
}

ListRepository()
{
    DebugTxt "ListRepository"
    ssh $SERVER_USER@$SERVER_IP "./Server.sh --list-repository"
}

# Options Handler
CheckArgs()
{
    while [ $# -ge 1 ]
    do
	case "$1" in
	    "-h"|"--help") Helper
			   exit 0
			   ;;
	    "--silent") VERBOSE=1
			;;
	    "--debug") DEBUG=0
			;;
	    "--configure") CONFIGURE_PG=0
			   ;;
	    "--create-repository"|"-Cr") if [ $# -ge 2 ] ; then
					     CREATE_REPO=0
					     shift
					     TARGET_REPOSITORY="$1"
					 else
					     Helper
					     exit 1
					 fi
					 ;;
	    "--clone-repository"|"-Cl") if [ $# -ge 2 ] ; then
					    CLONE_REPO=0
					    shift
					    TARGET_REPOSITORY="$1"
					else
					    Helper
					    exit 1
					fi
					;;
	    "--delete-repository"|"-D") if [ $# -ge 2 ] ; then
					    DELETE_REPO=0
					    shift
					    TARGET_REPOSITORY="$1"
					else
					    Helper
					    exit 1
					fi
					;;
	    "--list-repository"|"-L") LIST_REPO=0
				      ;;
            *)	Cred "$1 : invalid option."
		Helper
		exit 1
		;;
	esac
	shift
    done
}

# Options Checker
CheckOpt()
{
    local TOTAL=$(($CONFIGURE_PG + $CLONE_REPO + $CREATE_REPO + $LIST_REPO + $DELETE_REPO))
    if [ $TOTAL -eq 4 ] ; then
	return 0
    else
	Cred "Too many or less options."
	Helper
	exit 1
    fi
}

# Program Checker
CheckPrograms()
{
    hash $1 > /dev/null 2>&1
    if [ $? -eq 1 ] ;  then
	Cred "You need $1 to use this program."
    fi
}

# Start Function
DoStuff()
{
    if [ $CREATE_REPO -eq 0 ] ; then
	CreateRepository
    fi

    if [ $DELETE_REPO -eq 0 ] ; then
	DeleteRepository
    fi

    if [ $CLONE_REPO -eq 0 ] ; then
	CloneRepository
    fi

    if [ $LIST_REPO -eq 0 ] ; then
	ListRepository
    fi

    if [ $CONFIGURE_PG -eq 0 ] ; then
	ConfigureProgram
    fi
}

# Main
CheckPrograms git
CheckPrograms ssh
CheckArgs $@
CheckOpt
# Load Conf
if [ -f $CONF_FILE ] ; then
    source $CONF_FILE
else
    if [ $CONFIGURE_PG -eq 1 ] ; then
	Cred "Program is not configurated. Please use --configure option."
	exit 1
    fi
fi
DoStuff
