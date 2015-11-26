#!/bin/bash


dialog --inputbox 'Digite seu nome: ' 0 0 2>/tmp/nome.txt
        nome=$(cat /tmp/nome.txt)
        echo "O seu nome é: $nome" > out &
        
dialog                          \
        --title 'Saida do Nome' \
        --tailbox out           \
        0 0       
        
