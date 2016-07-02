#!/bin/bash

#------------------------------#
#
#
#
#------------------------------#

clear
read -p 'Qual é a sua rede?  ' rede
#bits=$(echo "$rede"|cut -d '/' -f 2)
#OU
bits=`echo "$rede"|cut -d '/' -f 2`

bits=$(( 32 - $bits))

hosts=$((2 ** $bits - 2 ))

echo "$hosts endereços que podem ser implementados nesta rede."
