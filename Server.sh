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
DELETE_REPO=1
LIST_REPO=1

## Program

# Options Functions

CreateRepository()
{
    if [ -d ~/repositories/$TARGET_REPOSITORY.git ] ; then
	echo "Repository already exist."
    else
	git init --bare ~/repositories/$TARGET_REPOSITORY.git
	echo "$TARGET_REPOSITORY Created."
    fi
}

DeleteRepository()
{
    if [ -d ~/repositories/$TARGET_REPOSITORY.git ] ; then
	rm -rf ~/repositories/$TARGET_REPOSITORY.git
	echo "$TARGET_REPOSITORY Deleted."
    else
	echo "Repository doesn't exist."
    fi
}

ListRepository()
{
    local TT=1
    for repo in `ls ~/repositories/`
    do
	TT=0
	echo $repo | sed -e 's/.git//g'
    done
    if [ $TT -eq 1 ] ; then
	echo "No Repositories."
    fi
}

# Options Handler
CheckArgs()
{
    while [ $# -ge 1 ]
    do
	case "$1" in
	    "--create-repository"|"-Cr") if [ $# -ge 2 ] ; then
					     CREATE_REPO=0
					     shift
					     TARGET_REPOSITORY="$1"
					 else
					     exit 1
					 fi
					 ;;
	    "--delete-repository"|"-D") if [ $# -ge 2 ] ; then
					    DELETE_REPO=0
					    shift
					    TARGET_REPOSITORY="$1"
					else
					    exit 1
					fi
					;;
	    "--list-repository"|"-L") LIST_REPO=0
				      ;;
            *)	Cred "$1 : invalid option."
		exit 1
		;;
	esac
	shift
    done
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

    if [ $LIST_REPO -eq 0 ] ; then
	ListRepository
    fi
}

# Main
CheckPrograms git
CheckArgs $@
DoStuff

