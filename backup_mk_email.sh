:log warning "Mikrotik Router Backup Started... Powered by KernelKill"
:local backupfile mt_config_backup
:local mikrotikexport mt_export_backup
:local sub1 ([/system identity get name])
:local sub2 ([/system clock get time])
:local sub3 ([/system clock get date])
:local company "IVRNET PROVEDOR LTDA"
:local adminmail1 joabe@ivrnet.com.br

 
# SMTP DYNAMIC 
:local gmailuser joabe@ivrnet.com.br
:local gmailpwd password
:local gmailport 587
 
:local gmailsmtp
:set gmailsmtp [:resolve smtp.gmail.com];
 
# ferramenta de configuração, opções do Gmail, 
/tool e-mail set address=$gmailsmtp port=$gmailport start-tls=yes from=$gmailid user=$gmailuser password=$gmailpwd
 
:log warning "$company : Criando novo arquivo de backup. . . "
 
#Comeca a criar os arquivos de backup e exporta o arquivo
/system backup save name=$backupfile dont-encrypt=yes
/export file=$mikrotikexport
 
:log warning "$company : O Processo de Bakup da IVRNET levara 10s para começar a criar o backup. O sistema pode ficar lento ..."
:delay 10s
 
:log warning "O Backup esta sendo enviado via Email usando GMAIL SMTP . . ."
 
# Inicia o envio de arquivos de e-mail , verifique se você tem uma seção de e-mail configurado antes. ou então ele irá falhar
/tool e-mail send to=$adminmail1 subject="$sub3 $sub2 $sub1 Configuração do arquivo de BACKUP" file=$backupfile start-tls=yes
/tool e-mail send to=$adminmail1 subject="$sub3 $sub2 $sub1 Configuração do  arquivo de EXPORT" file=$mikrotikexport start-tls=yes
 
 
:log warning "$company : BACKUP JOB: Espera por 30 segundos para  que o e-mail possa ser entregue, "
:delay 30s
 
# REMOVE o backup.
/file remove $backupfile
/file remove $mikrotikexport
 
# Imprime o log depois que o backup é enviado
:log warning "$company :Sistema de Backup : O Processo Acabou e o arquivo de Backup foi removido."
 
# Script END
