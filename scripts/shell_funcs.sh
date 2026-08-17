#!/bin/bash
# shell_funcs.sh - A collection of bash functions to facilitate my research workflow
# Author: Branko Meeus, lastfirst[at]gmail[dot]com
# License: DoWTFYouWant
#
# USAGE
#     set vim flavor and source in .bashrc to acces functions


VIM="gvim"
REPOS=($(ls -d /home/bmeeus/Documents/Overleaf/*/ | grep -v tmp/$))
REPOS+=( /home/bmeeus/dotfiles )
TDIR=/home/bmeeus/dotfiles/templates
NDIR=/home/bmeeus/research/notes
OBS=/home/bmeeus/Documents/Obsidian_Vaults/General

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
StartDay () {
    APPEND=false
    
    # Parse options
    while getopts ":a:" opt; do
	case $opt in
	    a) # Append to last note with variable date 
		APPEND=true
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
			APPEND=true
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
    if [[ $APPEND = true ]]; then
	echo Appending to Notebook of $PREVDATE
	cp $NDIR/$PREVDATE/note.xopp note.xopp
    else
	cp $TDIR/template_DN.xopp note.xopp
    fi

    # Create Tex notebook
    cp $TDIR/template_DN.tex note.tex

    # Open daily note
    cd $OBS 
    git pull
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
DN () {
    cd ~/Documents/Obsidian_Vaults/General/ 
    $VIM ./Dailies/$(date +%Y-%m-%d).md
}

# NB
# --------------------------------------------------------------------------------------
# Opens Xournal notebook
# --------------------------------------------------------------------------------------
NB () {
    xournalpp /home/bmeeus/research/notes/$(date +%Y-%m-%d)/note.xopp
}

# TNB
# --------------------------------------------------------------------------------------
# Opens Tex notebook
# --------------------------------------------------------------------------------------
TNB () {
    $VIM /home/bmeeus/research/notes/$(date +%Y-%m-%d)/note.tex
}

check_staged () {
    # Update the index
    git update-index -q --ignore-submodules --refresh
    err=0

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
	echo "In $1: you have unstaged changes."
	err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
	echo "In $1: your index contains uncommitted changes." 
	err=1
    fi

    if [ $err = 1 ]
    then
	return 1
    fi
}

EndDay () {
    IGNORE=0 
    OLDDIR=$PWD
    while getopts "i" opt; do
	case $opt in
	    i) echo ignoring uncommitted changes; IGNORE=1  ;;
	esac 
    done

    if [[ $IGNORE = 0 ]]
    then
	err=0
	for repo in "${REPOS[@]}"; do
	    cd $repo
	    result="${repo%"${repo##*[!/]}"}" # multi-trailing-/ trim
	    (check_staged "${result##*/}")
	    if [[ $? = 1 ]]
	    then
		err=1
	    fi
	done
	if [[ $err = 1 ]]
	then
	    echo Please commit them or run script with -i option
	    cd $OLDDIR
	    return 1
	fi
    fi 
    cd $OBS
    git add -A && git commit -m "Daily commit $(date +%Y-%m-%d)" && git push
    poweroff
}
