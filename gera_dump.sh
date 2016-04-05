#!/bin/sh
#Diretorio de destino do arquivos
DIR=/home/kernelkill/backup

#Listagem de todos os bancos de dados de seu SGBD
[!$DIR ] mkdir -p $DIR || :
LIST=$(su - postgres -c "psql -lt" |awk '{ print $1}' |grep -vE '^-|:|^List|^Name|template[0|1]')

#Laço com Dump, para cada banco listado acima, é gerado um dump, com a saída já compactada em .gz
for d in $LIST
do
su - postgres -c "/usr/bin/pg_dump --inserts $d | gzip -c $DIR/$d.sql.gz"
done

