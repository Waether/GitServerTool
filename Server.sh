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
            *)	echo "$1 : invalid option."
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
	echo "You need $1 to use this program."
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

    if [ $LIST_REPO -eq 0 ] ; then
	ListRepository
    fi
}

# Main
CheckPrograms git
CheckArgs $@
DoStuff

