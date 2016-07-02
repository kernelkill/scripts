#!/bin/bash

#Programa simples para criar usuario

echo "Digite o Login do usuario que voce deseja criar: "
read usr
useradd -m -d /home/$usr -s /bin/bash $usr
echo "Definindo a senha para  $usr: "
passwd $usr
