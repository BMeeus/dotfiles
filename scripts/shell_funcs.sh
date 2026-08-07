#!/bin/bash
# shell_funcs.sh - A collection of bash functions to facilitate my research workflow
# Author: Branko Meeus, lastfirst[at]gmail[dot]com
# License: DoWTFYouWant
#
# USAGE
#     set vim flavor and source in .bashrc to acces functions


VIM="gvim"

# StartDay
# --------------------------------------------------------------------------------------
# Creates note dir and files, opens daily note and obsidian, updates system every monday
#
# ARGUMENTS
#    -a date	Use Xournal notebook of previous date to append to.
#		Options:
#		    -empty: Use notebook of last workday
#		    -1-9: Use notebook of 1-9 days ago
#		    -YYYY-mm-dd: Use notebook of date specified
# EXIT CODES
#   0	Succes
#   1	Incorrect date passed  
# --------------------------------------------------------------------------------------
function StartDay {
    $TDIR=/home/bmeeus/dotfiles/templates
    $NDIR=/home/bmeeus/research/notes
    # Parse options
    while getopts ":a:" opt; do
	case $opt in
	    a) # Append to last note with variable date 
		case $OPTARG in
		    [1-9]) # Set previous date to X days ago
			PREVDATE=$(date +%Y-%m-%d --date "$OPTARG days ago")
			;;
		    *)
			# Set previous date to specified date
			if [[ $OPTARG =~ ^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$  ]]
			then
			   PREVDATE=$OPTARG
			else
			    echo "ERROR date must be empty, single digit, or YYYY-mm-dd"
			    exit 1
			fi
			;;
		esac
		;;
	    :)
		case $OPTARG in
		    a) # Default for previous date is last workday
			if [[ $(date +%u) -eq 1 ]]
			then
			    PREVDATE=$(date +%Y-%m-%d --date 'last Fri')
			else
			    PREVDATE=$(date +%Y-%m-%d --date 'yesterday')
			fi
			;;
		    *)
			echo ERROR option $OPTARG needs argument
		    ;;
		esac
		;;
	esac
    done

    # Make notes dir
    mkdir -p $NDIR/$(date +%Y-%m-%d); cd $NDIR/$(date +%Y-%m-%d)
    
    # Create xournal notebook
    if [[ -z "$PREVDATE" ]]; then
	cp $NDIR/$PREVDATE/note.xopp note.xopp
    else
	cp $TDIR/template_DN.xopp note.xopp
    fi
    
    # Create Tex notebook
    cp $TDIR/template_DN.tex note.tex
    
    # Open daily note
    cd ~/Documents/Obsidian_Vaults/General/ 
    $VIM ./Dailies/$(date +%Y-%m-%d).md
    
    # update on mondays
    if [[ $(date +%u) -eq 1 ]]
    then
	sudo apt upgrade && sudo apt update
    fi

    # Open obsidian
    obsidian
}

# DN
# --------------------------------------------------------------------------------------
# Opens Daily Note
# --------------------------------------------------------------------------------------
function DN {
    cd ~/Documents/Obsidian_Vaults/General/ 
    $VIM ./Dailies/$(date +%Y-%m-%d).md
}

# NB
# --------------------------------------------------------------------------------------
# Opens Xournal notebook
# --------------------------------------------------------------------------------------
function NB {
    xournalpp /home/bmeeus/research/notes/$(date +%Y-%m-%d)/note.xopp
}

# TNB
# --------------------------------------------------------------------------------------
# Opens Tex notebook
# --------------------------------------------------------------------------------------
function TNB {
    $VIM /home/bmeeus/research/notes/$(date +%Y-%m-%d)/note.tex
}
