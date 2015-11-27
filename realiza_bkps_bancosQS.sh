#!/bin/bash


###################################################################################
#                                                                                 #
#				AUTOR:	JOABE GUIMARÃES Q. KACHORROSKI            #
#				FUNÇÂO: REALIZA BACKUP MENSALMENTE DOS BANCOS     #
#				DATA: 	18/11/2015				  #
#				VERSÂO: 0.0.1					  #
#										  #
###################################################################################


#Variaveis que vai gerar os logs de sessão e de execução
WORKDIR="/var/log"
SESSION_LOG=${WORKDIR}/$$.log
LOGFILE=${WORKDIR}/backup_bancosQS.log

#Variaveis de autenticação do servidor FTP
FTPSERVER="endereço"
USER="user"
PASS="password"

#Verifica qual é o usuario atual
SUPER=$(whoami)

#Variaveis para validação da data
DATE="date +%d-%m-%Y"
DATE_HOJE="date +%d"
#RODA=$(date +%s -d ${DATE})

#Variaveis de comandos universais que serão usado
FTP="curlftpfs"
RSYNC="rsync -ravzup "

ORIGEM="Outros/"
DESTINO="backup_ftp/"


#Funcão para gerar log
function LOG(){
 DATA=$(date +"%d-%m-%Y")
 echo ${DATA} $1 | tee -a ${SESSION_LOG}
}

#Verifica se o usuario ROOT é quem esta executando o script
LOG "Verificando se o usuario 'e ROOT..."
if [ $SUPER != 'root' ]; then
	echo
	echo "===================================================="
	echo "= Este programa necessita de previlegios root para ="
	echo "= ser executado                                    ="
	echo "===================================================="
	echo
	exit 1
fi

LOG "Usuario ROOT reconhecido."

LOG "Realizando Conexão com o Servidor FTP..."
$FTP ftp://endereçoftp diretorio/de/montagem -o user="user:senha"
if [ $? -eq '0' ]; then
	LOG "  [ FTP Montado com Sucesso. ] "
else 
	LOG "  [ Desculpe ocorreu alguma falha durante o processo de montagem. ]"
	umount /mnt/FTP/
	exit 1	
fi

LOG "Iniciando a Transferencia dos Backups..."
$RSYNC -ravzup /ORIGEM/* /DESTINO 
if [ $? -eq '0' ]; then
#LOG "${DATE_HOJE}   full  ${RODA} ${RODA} 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" >> ${LOGFILE}
         LOG " [ Transferencia realizada com sucesso. ] "
  else
         LOG " [ Transferencia falhou. ] "
         umount /mnt/FTP/
         exit 1
  fi
   
  sleep 5
  umount /mnt/FTP/

#Salva o log da sessão no log geral
cat  ${SESSION_LOG} >>  ${LOGFILE}
