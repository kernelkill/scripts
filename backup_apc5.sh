#!/bin/bash
#=======================================================================#
#=======================================================================#

## backup_apc5.sh - Scripts para gerar backups e enviar para FTP e Email.
## Escrito por: Joabe Guimaraes Querino Kachorroski  (Campo Grande - MS)
## E-mail: joabejbk@gmail.com
## Sistemas Operacional: Ubuntu GNU/Linux 12.04
## Data de criação deste scriptQuin 29/09/2016 às14:05:09
## Versão:0.1

#=======================================================================#
#=========== CONFIGURACAO GLOBAL DE ACESSO SSH DOS RADIOS ==============#
ssh_user="admivr"
ssh_pass="1vrn3ts3gur02016"
ssh_porta="22"

ssh1_user="admin"
ssh1_pass="admin01"
ssh1_porta="22"

#================== CONFIGURACAO GLOBAL DO E-MAIL === ==================#
de="backupmikrotik@ivrnet.com.br"
para="joabe@ivrnet.com.br"
smtp="smtp.gmail.com"
porta="587"
user="backupmikrotik@ivrnet.com.br"
senha="1vrn3ts3gur02016"

#============== COMANDO PARA PEGAR O ARQUIVO DE CONFIGURACAO ===========#
comando="cat /tmp/system.cfg"
aps_online="/home/intelbras/mkauthapc/aps_online.txt"
aps_offline="/home/intelbras/mkauthapc/aps_offline.txt"
aps_contabilizados="/home/intelbras/mkauthapc/total_aps.txt"
radio=`sed -e '/6.67/!d' /home/intelbras/mkauthapc/apc.txt`

#=================== LIMPA BACKUPS ANTIGOS ==============================#
#INICIANDO O SCRIPT
echo "Aguarde!!! Localizando e Excluindo Backups Antigos."
sleep 5
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
#!/bin/bash
#=======================================================================#
#=======================================================================#

## backup_apc5.sh - Scripts para gerar backups e enviar para FTP e Email.
## Escrito por: Joabe Guimaraes Querino Kachorroski  (Campo Grande - MS)
## E-mail: joabejbk@gmail.com
## Sistemas Operacional: Ubuntu GNU/Linux 12.04
## Data de criação deste scriptQuin 29/09/2016 às14:05:09
## Versão:0.1

#=======================================================================#
#=========== CONFIGURACAO GLOBAL DE ACESSO SSH DOS RADIOS ==============#
ssh_user="user"
ssh_pass="password"
ssh_porta="22"

ssh1_user="user"
ssh1_pass="user"
ssh1_porta="22"

#================== CONFIGURACAO GLOBAL DO E-MAIL === ==================#
de="backupmikrotik@ivrnet.com.br"
para="joabe@ivrnet.com.br"
smtp="smtp.gmail.com"
porta="587"
user="backupmikrotik@ivrnet.com.br"
senha="password"

#============== COMANDO PARA PEGAR O ARQUIVO DE CONFIGURACAO ===========#
comando="cat /tmp/system.cfg"
aps_online="/home/intelbras/mkauthapc/aps_online.txt"
aps_offline="/home/intelbras/mkauthapc/aps_offline.txt"
aps_contabilizados="/home/intelbras/mkauthapc/total_aps.txt"
radio=`sed -e '/6.67/!d' /home/intelbras/mkauthapc/apc.txt`

#=================== LIMPA BACKUPS ANTIGOS ==============================#
#INICIANDO O SCRIPT
echo "Aguarde!!! Localizando e Excluindo Backups Antigos."
sleep 5
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

echo "Aguarde!!! Estamos Verificando se os Paineis estão Online..."
sleep 5
for apc in $(cat /home/intelbras/mkauthapc/apc.txt);do
        ping -q -c2 $apc > /dev/null

if [ $? -eq 0 ]
        then
        echo $apc "Online"
        echo $apc "Online" >>  $aps_online
else
        echo $apc "Offline"
        echo $apc "Offline" >> $aps_offline
fi
done
sleep 2
echo "Obrigado, Radios verificado com sucesso, foi gerado um arquivo com com IPs online e offline."
sleep 5
echo "Aguarde!!! Estamos acessando os Radios e gerando os Backups."
if [ "$radio" = "172.16.6.67" ];then
        for apc in $(cat /home/intelbras/mkauthapc/apc1.txt); do
         sudo sshpass -p "$ssh1_pass" ssh -o StrictHostKeyChecking=no $apc -l $ssh1_user -p $ssh1_porta "$comando" >  /home/intelbras/mkauthapc/apc5/cfg/backup-$apc.cfg
        done
fi

        for apc in $(cat /home/intelbras/mkauthapc/apc2.txt); do
         sudo sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $apc -l $ssh_user -p $ssh_porta "$comando" > /home/intelbras/mkauthapc/apc5/cfg/backup-$apc.cfg	
        done

echo "Aguarde!!! Contabilizando quantos Backups foram feitos."

find /home/intelbras/mkauthapc/apc5/cfg  -type d | \
while read line
do

    echo "$line" && ls -l "$line" | grep -v ^total | wc -l >> $aps_contabilizados
done

echo "Aguarde!!! Estamos compactando os Backups."
sleep 5
#======================== ENVIAR E-MAIL ================================#
#COMPACTANDO PARA ENVIAR POR E-MAIL
dia="`date +%d-%m-%Y`"
cd /home/intelbras/mkauthapc/apc5/
tar -zcvf backup-apc-$dia.tgz cfg

echo "Backups Compactados."
sleep 5
#ANEXANDO BACKUP
arq_tgz="`find /home/intelbras/mkauthapc/apc5 -mtime -1 -name '*.tgz'`"
anexo="$arq_tgz"
#ANEXA ASSUNTO E MENSAGEM
assunto="Backup dos Radios APC5+ `date +%d/%m/%Y`"
mensagem="Segue em anexo os Backup dos Radios APC5+.... Backups gerado e enviado automaticamente pelo Serv$

#========================================================================#
#ENVIANDO E-MAIL
#========================================================================#
#ENVIANDO E-MAIL
echo "Enviando E-mail com Backups e logs..."
sendEmail -f $de -t $para -u "$assunto" -m "$mensagem" -a $anexo $aps_online $aps_offline $aps_contabilizados -s $smtp:$porta -xu $user -xp $senha
#========================================================================#


