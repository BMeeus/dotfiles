#!/bin/bash

d=$(date +%Y-%m-%d)
mkdir /home/bmeeus/research/notes/$d
touch /home/bmeeus/research/notes/$d/note.xoj
touch /home/bmeeus/research/notes/$d/note.tex

cd ~/Documents/Obsidian_Vaults/General/ 

gvim ./Dailies/$(date +%Y-%m-%d).md

if ["$(date +%a)" = "Tue"]; then
    echo Hallo\n
else
    echo "$(date +%a)"
fi

obsidian
