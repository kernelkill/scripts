#!/bin/sh

zenity --forms --title="Adicionar Amigos" \
	--text="Entre com Informaçoes sobre seu Amigo." \
	--separator="," \
	--add-entry="Primeiro Nome" \
	--add-entry="Segundo Nome"\
	--add-entry="Apelido" \
	--add-entry="Email" \
	--add-calendar="Data de Aniversario" >> addr.csv

case $? in
    0)
        echo "Amigo Adicionado."
        ;;
    1)
        echo "Amigo nao foi adicionada."
	;;
    -1)
        echo "Opção inexistente"
	;;
esac
