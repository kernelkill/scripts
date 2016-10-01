#!/bin/bash
# for by Frnks
#
# Script para instalar e configurar um servidor FTP
# Duvidas entre em contato com o email:
# suporte_douglas@mksolutions.com.br
#

cor="\033[0m"
vermelho="\033[0;31m"
azulclaro="\033[0;34m"
azulclarofundo="\033[44;1;37m"
azulclaro="\033[1;34m"
amarelo="\033[1;33m"
verde="\033[0;32m"

installFtp(){
# Instalar pacotes necessarios ....
# Atualiza pacotes do Ubuntu
apt-get update
# Instala o serviço FTP
apt-get install vsftpd -y

# Configura o serviço FTP alterar permissões  /etc/vsftpd.conf

sed -i -r '/^anonymous_enable=/ c anonymous_enable='NO'' /etc/vsftpd.conf
sed -i -r '/^#local_enable=/ c local_enable='YES'' /etc/vsftpd.conf
sed -i -r '/^#write_enable=/ c write_enable='YES'' /etc/vsftpd.conf

# adicionar /bin/false 

echo >> /etc/shells '/bin/false'

}
criaUsuario(){
echo
echo
echo -e "$verde Digite o usuario do FTP: $cor"
read userFtp
sleep 2
# Cria pasta do usuario
mkdir /home/$userFtp
#cria uruario e pasta
useradd $userFtp -d /home/$userFtp/ -s /bin/false
#cria a senha
echo
echo
echo -e "$verde Digite a senha do usuario $userFtp do FTP: $cor"
echo
echo
sleep 2
passwd $userFtp 

# Permissão de escrita
chown $userFtp:$userFtp   /home/$userFtp

#Reiniciar o serviço e testar
echo
echo "Reiniciando Servico FTP... "
echo
sleep 3
/etc/init.d/vsftpd restart

	
}
FTP(){
echo
echo -e " $verde Comecando o procedimento de instalacao e configuracao do FTP. $cor"
echo
sleep 3
installFtp
criaUsuario
}
Principal(){
	clear
	echo
	echo -e " $azulclarofundo --- Instalar FTP Server --- $cor"
	echo
	echo -e " $azulclaro     1 - Instalar FTP $cor"
	echo -e " $azulclaro     0 - Exit $cor"
	echo
	echo -n "     Digite a opcao desejada: "
	read opcao
	case $opcao in
		1) FTP ;;
		0) exit ;;
		*) clear; echo ; Principal ;;
	esac
}
Principal
exit 0