#!/bin/bash
#=======================================================================#
#=======================================================================#

## backup_apc5.sh - Scripts para gerar backups e enviar para FTP e Email.
## Escrito por: Joabe Guimaraes Querino Kachorroski  (Campo Grande - MS)
## E-mail: joabejbk@gmail.com
## Sistemas Operacional: Ubuntu GNU/Linux 12.04
## Data de criação deste scriptQuin 29/09/2016 às14:05:09
## Versão: 00.1

#=======================================================================#
#======= CONFIGURACAO DE USUARIO,SENHA E PORTA SSH DOS RADIOS ==========#
ssh_user="user"
ssh_pass="senha"
ssh_porta="22"


ssh1_user="user"
ssh1_pass="senha"
ssh1_porta="22"

#============== CONFIGURACAO DO E-MAIL QUE VAI ENVIAR ==================#
de="backupmikrotik@ivrnet.com.br"
para="joabe@ivrnet.com.br"
smtp="smtp.gmail.com"
porta="587"
user="backupmikrotik@ivrnet.com.br"
senha="1vrn3ts3gur02016"
#============== COMANDO PARA PEGAR O ARQUIVO DE CONFIGURACAO ===========#
comando="cat /tmp/system.cfg"

#=================== LIMPA BACKUPS ANTIGOS ==============================#
#INICIANDO O SCRIPT
echo "Aguarde!!! Excluindo Backups Antigos."

DIR="/home/intelbras/mkauthapc/apc5/"
DIAS="1"
CMD="find $DIR -name "*.tgz" -ctime +$DIAS -exec rm{} \;"
ARQ="/tmp/bkp_old.log"

$CMD &> $ARQ 2> /dev/null
AUX=$(cat $ARQ | wc -l)
if [ $AUX = 0 ]; then
   echo "Nenhum backup com mais de $DIAS dia(s) para excluir!"
else
   $CMD | xargs rm -rf
   echo "Backup(s) com mais de $DIAS dia(s) de criaçao excluido(s)!"
   rm -rf $ARQ
fi

echo "Aguarde!!! Estamos acessando os Radios e gerando os Backups."
#EXECUTAR COMANDO  VIA SSH
radio=`sed -e '/6.67/!d' /home/intelbras/mkauthapc/apc.txt`

if [ "$radio" = "172.16.6.67" ];then
        for apc in $(cat /home/intelbras/mkauthapc/apc1.txt); do
         sudo sshpass -p "$ssh1_pass" ssh -o StrictHostKeyChecking=no $apc -l$
        done
fi

        for apc in $(cat /home/intelbras/mkauthapc/apc.txt); do
        sudo sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $apc -l $ssh_user -p $ssh_porta "$comando" $
        done


find /home/intelbras/mkauthapc/apc5/cfg  -type d | \
while read line
do

    echo "$line" && ls -l "$line" | grep -v ^total | wc -l > qtd.txt

done
#======================== ENVIAR E-MAIL ================================#
#COMPACTANDO PARA ENVIAR POR E-MAIL
dia="`date +%d-%m-%Y`"
cd /home/intelbras/mkauthapc/apc5/
tar -zcvf backup-apc-$dia.tgz cfg

#ANEXANDO BACKUP
arq_tgz="`find /home/intelbras/mkauthapc/apc5 -mtime -1 -name '*.tgz'`"
anexo="$arq_tgz"
#ANEXA ASSUNTO E MENSAGEM
assunto="Backup dos Radios APC5+ `date +%d/%m/%Y`"
mensagem="Segue em anexo os Backup dos Radios APC5+.... Backups gerado automaticamente pelo Servidor."

#========================================================================#
#ENVIANDO E-MAIL
echo "Enviando E-mail..."
sendEmail -f $de -t $para -u "$assunto" -m "$mensagem" -a $anexo -s $smtp:$porta -xu $user -xp $senha
#========================================================================#


