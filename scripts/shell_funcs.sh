#!/bin/bash

function StartDay {
    mkdir /home/bmeeus/research/notes/$(date +%Y-%m-%d)
    cd /home/bmeeus/research/notes/$(date +%Y-%m-%d)
    cp /home/bmeeus/dotfiles/templates/template_DN.xopp note.xopp
    cp /home/bmeeus/dotfiles/templates/template_DN.tex note.tex

    cd ~/Documents/Obsidian_Vaults/General/ 
    gvim ./Dailies/$(date +%Y-%m-%d).md

    if ["$(date +%a)" = "Tue"]; then
	echo Hallo\n
    else
	echo "$(date +%a)"
    fi

    obsidian
}

function DN {
    cd ~/Documents/Obsidian_Vaults/General/ 
    gvim ./Dailies/$(date +%Y-%m-%d).md
}

function NB {
    xournalpp /home/bmeeus/research/notes/$(date +%Y-%m-%d)/note.xoj
}


function TNB {
    gvim /home/bmeeus/research/notes/$(date +%Y-%m-%d)/note.tex
}


