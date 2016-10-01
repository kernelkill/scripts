log warning "Startando Configuracao do Script de Backup Automatico "

#Carregando variaveis Globais de Data e hora
#Data do MK
:global data [/system clock get date]
:global datetimestring ([:pick $data 0 3] ."-" . [:pick $data 4 6] ."-" . [:pick $data 7 11])
#Hora do MK
:global hora [/system clock get time]
:global temp ([:pick $hora 0 2].":".[:pick $hora 3 5].":".[:pick $hora 6 8])


#Executa o backup concatenando a data e hora atual
/system backup save name="$[/system identity get name]_$datetimestring_$temp" 
log error "backup finalizado...!!!"

#Executa a exportacao do arquivo rsc concatenando data e hora atual
/export compact file="$[/system identity get name]_$datetimestring_$temp"
log error "export finalizado...!!!"

log warning "Por favor aguarde 10 segundos até iniciar a transferencia do arquivo!!!"
:delay 10s

log warning "Iniciando o envio dos  arquivo de backup e rsc do Mikrotik via FTP...!!!"
#Inicia o envio do arquivo de backup
/tool fetch address=177.85.176.10 src-path="$[/system identity get name]_$datetimestring_$temp.backup" user=mksolutions password=mk@novo@mk port=21 upload=yes mode=ftp dst-path="$[/system identity get name]_$datetimestring_$temp.backup"
log info "Arquivo de backup enviado"

log warning "Aguarde até que o proximo arquivo seja enviado"
:delay 30s

log warning "Iniciando o envio do proximo arquivo"
#Inicia o envio do arquivo de export
/tool fetch address=177.85.176.10 src-path="$[/system identity get name]_$datetimestring_$temp.rsc" user=mksolutions password=mk@novo@mk port=21 upload=yes mode=ftp dst-path="$[/system identity get name]_$datetimestring_$temp.rsc"
log info "Arquivo de rsc enviado"

log warning "Aguarde ate que o processo seja encerrado...."
:delay 30s

log error "Removendo Arquivos de backups"
/file remove "$[/system identity get name]_$datetimestring_$temp.backup"
/file remove "$[/system identity get name]_$datetimestring_$temp.rsc"

:delay 10s
log error "Sistema de Backup Finalizado...!!!!"