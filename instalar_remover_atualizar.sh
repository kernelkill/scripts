#!/bin/bash

#Autor: Joabe Kachorroski.
#Data: 22/05/2015.
#Algoritmo que disponibilize uma lista de escolha para o usuário poder procurar, instalar ou remover.
#um pacote de software para o sistema Linux.
#Versão 1.0

echo "##############################################"
echo "### Procurar, Atualiza e Desistalar Pacote ###"
echo "###          GNU/Linux é o que É           ###"
echo "##############################################"

echo "Escolha uma opção!"
echo "(1) Atualizar Sistema"
echo "(2) Procurar Pacote"
echo "(3) Instalar Pacote"
echo "(4) Desistalar Pacote"
read op

case $op in
        1) echo -n "Sistema esta sendo atualizado"
        reado pkg
        apt-get update $pkg
        ;;
        
        2) echo -n "Informe o Pacote: "
        read pkg
        apt-cache search $pkg
        ;;
        
        3) echo -n "Informe o Pacote: "
        read pkg
        apt-get install $pkg
        ;;
        
        4) echo -n "Informe o Pacote: "
        read pkg
        apt-get remove --purge $pkg
        ;;
        
        *) echo "Comando invalido"
        esac
        exit
