#!/bin/bash

#Autor: Joabe Kachorroski
#Data: 26/05/2015
#Sobre: Programa para fazer backup via conexao automatizada com ssh.
#Versão: 0.1


echo "####################################################"
echo "########### FAZENDO BACKUP DOS ARQUIVOS ############"
echo "###########          BACKFILE           ############"
echo "####################################################"



SYNC_LOG=/var/log/rsync.log
echo ""
echo "==================================================================" >> $SYNC_LOG
echo "INICIANDO REALIZAÇÃO DE BACKUP............" >> $SYNC_LOG
date >> $SYNC_LOG

echo "Fazendo a conexão segura via SSH.........." >> $SYNC_LOG
#sshpass -p zabbix ssh zabbix@10.1.2.192

echo "Iniciando sincronização..............." >> $SYNC_LOG
echo "Os Seguintes Arquivos foram copiados..........." >> $SYNC_LOG
rsync -Cravzp -b /home/kernelkill/bkp/ root@10.1.2.192:/home/zabbix/backupclientes >> $SYNC_LOG


echo "Os arquivos Foram copiadas com sucesso........." >> $SYNC_LOG
echo "Conexão Finalizada............." >> $SYNC_LOG
echo "==================================================================" >> $SYNC_LOG
echo "==================================================================" >> $SYNC_LOG

 
