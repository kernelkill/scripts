#!/bin/sh

# Script para backup dos bancos de dados

# Executa vaccum no banco
#su postgres -c "/usr/bin/vaccumdb -a -z -f -q"

# Formata data para adicionar ao nome dos arquivos
t=`/bin/date +%d%m%y`
tt=`/bin/date +%H%M%S`

# Define o destino dos arquivos
DST="/opt/data/backup/$t"

# Cria o diretório do dia se ele não existir
if [ -d /opt/data/backup/$t ]; then
  cd /opt/data/backup/$t
else
`mkdir -p /opt/data/backup/$t`
fi

# Define permissoes de leitura e gravacao para o diretorio
`chown -R postgres /opt/data/backup/`
`chown -R postgres /opt/data/backup/$t`
`chmod 0777 /opt/data/backup/$t`

# Loop para gerar arquivos dump
for i in `psql -l -U postgres | cut -f 2 -d " " -s`; do
    if [ $i != template1 -a $i != template0 -a $i != "rows)" -a $i != postgres ]; then
        su postgres -c '/usr/bin/pg_dump -p 5432 -U postgres -c -d -F -f $DST/$t/$i"_"$t"_"$tt.bkp -Z 1 $i';
    fi
done
