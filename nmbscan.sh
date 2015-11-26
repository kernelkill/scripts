#!/bin/bash


TITLE="NMBSCAN"

IP=$(zenity --title="$TITLE - Scaneamento Local"\
            --text="Digite o IP a Ser Scaneado: "\
            --entry --height=150 --width=350)
        
        [ $? -ne 0 ] && --zenity --text="Esc ou CANCELAR apertado" --error && exit
        
        nmblookup -A $IP > result.txt
        
        zenity --title="Resultado da Busca" --text-info --filename result.txt --editable --height=290\
               --width=400
        
        rm result.txt
