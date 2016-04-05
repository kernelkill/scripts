#!/bin/bash
#
# Um simples script de backup
# Autor: Jonas Ferreira

# db_array - lista dos bancos que se deseja fazer o dump
db_array="biblioteca"

# logfile - arquivo que grava o log de cada execucao do script
logfile="/home/kernelkill/backup/pgsql-backup.log"

#Diretorio de destino do arquivos
#DIR=/home/kernelkill/backup

for db in $db_array
do
       /usr/bin/pg_dump -U postgres $db > /home/kernelkill/backup/$db.sql 1>> $logfile 
        
done
