#!/bin/bash

# Criamos algumas variáveis para ajudar no nosso script
NAMELOG="dump_perseuescola2"
DATABACKUP=`date +%d-%m-%Y`
BKPPATH="/home/kernelkill/backup"

# Este é o nome real de sua base de dados no postgres,
# por exemplo: "minhaloja", "base-wordpress", etc...
NOMEBASE="perseuescola2"


# Vamos gerar um log para registrar 
# os sucessos ou falhas do nosso script
ORG="/var/log/"
LOG="$ORG"backup_"$NAMELOG.log"

# Nome final do nosso dump:
NOMEDUMP=dump-$NOMEBASE-full-$DATABACKUP.gz

cd $BKPPATH

# Remove backups gerados anteriormente, 
# caso você queira ficar apenas com o último backup feito.
# Se você preferir ficar guardando os backups 
# basta comentar ou remover a linha abaixo
# (atenção com o espaço em disco ok?)
#rm -f $BKPPATH* 2 >> $LOG

echo " " >> $LOG
echo "###########################" >> $LOG
echo " " >> $LOG
echo "Inicio em: " `date` >> $LOG
echo " " >> $LOG

#Aqui fazemos o dump propriamente dito:
echo "Inicio do DUMP em: " `date` >> $LOG
pg_dump -U postgres -d $NOMEBASE | gzip > $NOMEDUMP

echo "Fim do DUMP em: " `date` >> $LOG
