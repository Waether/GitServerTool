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
## Version 1.0
#

## Dev Tool

# Colors

NO_COLOR="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"

Cgreen() { echo -e "$COLOR_GREEN$@$NO_COLOR"; }
Cred() { echo -e "$COLOR_RED$@$NO_COLOR"; }

## Globals Var

# Flags
CREATE_REPO=1
CLONE_REPO=1
DELETE_REPO=1
LIST_REPO=1
CONFIGURE_PG=1

# Content
CONF_FILE=~/.git-server-tool.conf
CONF_FILE_BCP=~/.git-server-tool.conf.bcp
TARGET_REPOSITORY=""

## Program

# Helper
Helper()
{
    echo -e "usage: Client.sh <command> [args]"
    echo -e "\t--create-repository -Cr <repo-name>"
    echo -e "\t\tCreate a git repository"
    echo -e "\t--clone-repository -Cl <repo-name>"
    echo -e "\t\tClone a git repository into the current directory"
    echo -e "\t--delete-repository -D <repo-name>"
    echo -e "\t\tDelete a git repository"
    echo -e "\t--list-repository -L"
    echo -e "\t\tList all repository in your server"
    echo -e "\t--help -H"
    echo -e "\t\tDisplay this helper"
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
    ssh $SERVER_USER@$SERVER_IP "./Server.sh --create-repository $TARGET_REPOSITORY"
}

DeleteRepository()
{
    ssh $SERVER_USER@$SERVER_IP "./Server.sh --delete-repository $TARGET_REPOSITORY"
}

CloneRepository()
{
    git clone $SERVER_USER@$SERVER_IP:~/repositories/$TARGET_REPOSITORY.git
}

ListRepository()
{
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
	exit 1
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
