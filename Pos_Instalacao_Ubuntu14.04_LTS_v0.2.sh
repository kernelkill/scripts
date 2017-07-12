#!/bin/bash

### CRÉDITOS:

### WAGNER ARESTIDES: RESPONSÁVEL PELA CONFIGURAÇÃO E LISTA DE PACOTES PARA INSTALAÇÃO
### EMAIL: wagner2308@gmail.com

### VALSON PEREIRA: RESPONSÁVEL PELA A IMPLEMENTAÇÃO DO CÓDIGO
### EMAIL: valson.pereira@gmail.com

### KERNELKILL: NOVAS IMPLEMENTAÇÕES
### EMAIL: kernelkill@protonmail.com

################################# APLICATIVO POS INSTALAÇÃO UBUNTU 14.04 LTS ##################################	
################################# Iniciando Funçoes Globais ###################################################
# param: URL para download
# Checa se a URL é valida, retorna informação para o header
checkURL() {
    url=$1
    response=$( wget --spider --server-response --user-agent="$userAgent" $url 2>&1 )
    echo $response
}

# param: Informação do HEADE retornado pelo checkURL()
# Encontra a URL no HEAD da informação e devolva-o
getURL() {
    url=$( echo $1 | sed -n 's/.*\(http[^ ]*\).*/\1/p' | head -n1 )
    echo $url
}

# param: URL final para baixar o arquivo
# Encontre o nome do arquivo de URL sem parâmetro após o nome do arquivo. Suporta apenas URL sem parâmetro após o nome do arquivo
getExtension() {
    url=$(basename "$1" )
    extension="${url##*.}"
    echo $extension
}

# param: URL final para baixar o arquivo
# Encontre o nome do arquivo de URL sem parâmetro após o nome do arquivo. Suporta apenas URL sem parâmetro após o nome do arquivo
getFileName() {
    url=$(basename "$1" )
    mFile="${url%.*}"".${url##*.}"
    echo $mFile
}

# param: URL final to download file
# Encontra o nome do arquivo do URL para fazer o download. Suporte a URL com parâmetro após o nome do arquivo
forceGetFileName() {
    url=$( echo $1 | sed -n 's/.*\(http[^ |?|&]*\).*/\1/p' | head -n1 )
    url=$(basename "$url" )
    mFile="${url%.*}"".${url##*.}"
    echo $mFile
}

#
# param: Nome do pacote, caminho para arquivo baixado, arquivo de extensão baixado
# Instala os pacotes baixados, é aqui que a magica acontece.
installPackage() {

    #Nome do Pacote
    package=$1;

    #Caminho do arquivo baixado
    path=$2;

    extension=$3;

    if [ "$package" == "Java JRE" ];  then

        
        $DIRECTORY="/opt/java"

        #Verifica se o diretorio existe
        if [ ! -d "$DIRECTORY" ]; then
            #Diretorio não existe, entao cria
            mkdir /opt/java
        fi

        #EExtraia o arquivo e copia para o diretório de instalação
        tar xvf "$path" -C "$DIRECTORY"

        #Navega até o diretorio de instalaçao
        cd $DIRECTORY

        #Crie um link simbólico para o diretório extraído que foi instalado 
        ln -s jre* jre

    elif [ "$extension" == "deb" ];  then

    	#Instala pacotes .deb
		dpkg -i "$path"

		#Verifique se a instalação tem algum erro
    	if [ ! $? -eq 0 ]; then

    		#Força instalar pacotes de dependencia
		    apt-get -f install

		fi

	elif [ "$extension" == "bz2" ];  then

    	if [ "$package" == "Firefox" ]; then

    		tar xf "$path" -C /optx

		fi

    fi

}

#
# param: pacotes
# Esse cara aqui configura qualquer pacote que precise de configuração
configPackage() {

    #Pega o nome do Pacote
    package=$1

    #Verifique se o pacote é java
    if [ "$package" == "Java JRE" ];  then

        #Adicionar variável de ambiente do Java
        data='export JAVA_HOME="/opt/java/jre"'"\n"'export CLASSPATH="$JAVA_HOME/lib":$CLASSPATH'"\n"'export PATH="$JAVA_HOME/bin":$PATH'"\n"'export MANPATH="$JAVA_HOME/man":$MANPATH'

        #Aquela adicionado marota na primeira linha do arquivo /etc/profile
        sed -i "1i $data" /etc/profile

        #Cria um link simbólico java em bin para usar para todos os usuários
        ln -s /opt/java/jre/bin/java /usr/local/bin/

        #Crie um link simbólico javac em bin para usar para todos os usuários
        ln -s /opt/java/jre/bin/javac /usr/local/bin/

    fi

}

# param: Criando um atalho
# Esse cara aqui faz simplesmente um atalho.
createLaunchMenu() {
    savefile="/home/$USER/.local/share/applications/";
    appName=$1;
    toExec=$2;
    icon=$3;
    filename=$4;
    savefile=$savefile$filename
    text="[Desktop Entry]\nComment=\nTerminal=false\nName=$appName\nExec=$toExec\nType=Application\nIcon=$icon";
    touch $savefile;

cat > "$savefile" << EOF
[Desktop Entry]
Comment=
Terminal=false
Name=$appName
Exec=$toExec
Type=Application
Icon=$icon
EOF
}


downloadPackage() {

    #Pega a url para baixar o arquivo
    url=$1

    #Pega o noma do pacote
    packageName=$2

    #Obtenha condição para forçar o nome do arquivo ou não
    forceGetFilename=$3

    #Verifique se o link é válido
    response=$(checkURL $url )

    #Verifique se o link está quebrado
    if echo $response | grep -q 'Not Found Remote file'; then

        #O link está quebrado? entao salve o registro.
        sed -e "$packageName: O link está quebrado! Salvando o arquivo em file.txt" file.txt

        echo "0"

    else

        #Extraia apenas o URL do cabeçalho para baixar o arquivo
        url=$(getURL "$response" )

        extension=$(getExtension "$url");

        if [ $forceGetFilename -eq "1" ]; then
            #Obtenha o nome do arquivo com a função FORCE (Java tem um parâmetro no URL, este parâmetro é essencial para o LINK válido para download)
            filename="downloads/"$(forceGetFileName "$url")
        else
            #Obtem o filename
            filename="downloads/"$(getFileName "$url")
        fi

        #download do arquivo
        wget -O $filename --user-agent="$userAgent" $url

        #Instala o pacote baixado
        installPackage "$packageName" "$filename" "$extension"

        #Configura o pacote baixado
        configPackage "$packageName"

        #Retorna 1
        echo "1"

    fi    
}

#
# param: url, user agent
# Baixe a página de origem do pacote, para obter url para baixar
dowloadSourcePage() {

    #pega a url
    url=$1

    #pega o user agent
    userAgent=$2

    #Conecte-se a uma página para baixar o java e obtenha a fonte
    wget --user-agent="$userAgent" "$url" -q -O file.html

}

# param: inserir aqui o link do pacote que quer baixar
links=(
	"https://www.teamviewer.com/pt/download/linux/"
    #"https://www.java.com/pt_BR/download/linux_manual.jsp"
    #"https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    #"https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megasync-Debian_9.0_amd64.deb"
    #"http://dbeaver.jkiss.org/download"
    #"https://www.sublimetext.com/3"
    #"https://www.mozilla.org/pt-BR/firefox/new"
    #"https://www.mozilla.org/pt-BR/firefox/developer/"
    #"https://developer.android.com/studio/index.html"
    #"https://desktop.telegram.org/"
    
    #"https://clipgrab.org/"
    #"https://launchpad.net/kazam"
)
################################## Finalizando Funçoes Globais ################################################

function MenuPrincipal()
{
clear

VERSAO=lsb_release\ --short\ --description

$VERSAO && echo "*********** Bem Vindo ao Aplicativo Pós instalaçao *************"


CONDICAO=1

	while [ $CONDICAO !=  0 ]

            do
echo "
Digite a opcao:

1- baixar e instalar Pacotes Básicos
2- Pacotes Extras
3- Sair "
	read OPCAO
		
		case $OPCAO in
			1)instalacaoPacotesBasicos;;

                          
			2)menuExtra;;
                          
                        3)echo "Encerrando o Script"
			  CONDICAO=0;;
                        
                        *) echo "Opcao Invalida...";; 	 
                esac   
           done
}

################################## DEMAIS FUNÇOES ##########################################


################################# INSTALAÇÃO BÁSICA #######################

function instalacaoPacotesBasicos()
{

clear
echo "
Instalando repositórios necessários para obtenção de pacotes...
Para Cancelar a instalação pressione CTRL + C
"

add-apt-repository ppa:otto-kesselgulasch/gimp -y && add-apt-repository ppa:webupd8team/java -y \
&& add-apt-repository ppa:freyja-dev/unity-tweak-tool-daily -y && add-apt-repository ppa:samrog131/ppa -y && apt-get update


echo "
Baixando e instalando Pacotes Básicos...
"

apt-get install faac faad ffmpeg-real ffmpeg2theora flac icedax id3v2 lame libflac++6 libjpeg-progs \ 
libmpeg3-1 mencoder mjpegtools mp3gain mpeg2dec mpeg3-utils mpegdemux mpg123 mpg321 regionset sox uudeview \ 
vorbis-tools x264 arj p7zip p7zip-full p7zip-rar rar unace-nonfree flashplugin-installer ttf-ubuntu-font-family \
ubuntu-restricted-extras vlc lame preload prelink bum rcconf dialog wine gecko-mediaplayer gimp gimp-plugin-registry \
gimp-gmic xsane devede k3b libk3b-dev libk3b6-extracodecs ripperx audacity winff ssh portmap nfs-common yakuake \
hardinfo chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra samba htop kdegames gnome-games \
supertux frozen-bubble qt4-qtconfig vim language-pack-kde-pt language-pack-pt-base language-pack-pt \
language-pack-gnome-pt-base language-pack-gnome-pt glipper clementine -y \
&& sudo /usr/share/doc/libdvdread4/install-css.sh && sudo apt-get install \
unity-tweak-tool oracle-java7-installer zram-config mesa-utils libxss1 -y \
&& cd /tmp && apt-get install debdelta -y && sudo debdelta-upgrade && sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y ; sudo apt-get autoclean ; 
sudo updatedb && sudo prelink -amR


}

############################ EXTRAS #####################################################################

##### INSTALACO TLP ###########

function instalacoTLP()
{

clear
echo "
Instalando o TLP gerenciador de Energia de notebooks....
Para Cancelar a instalação pressione CTRL + C
"

add-apt-repository ppa:linrunner/tlp -y && apt-get update && apt-get install tlp tlp-rdw -y ; tlp start

echo "
TLP Instalado com sucesso
"

}

######## INSTALACAO GOOGLE CHROME ############

function instalacaoChrome()
{

clear
echo "
Instalando o Google Chrome
Para Cancelar a instalação pressione CTRL + C
"
if [ "$ARCH" = "32" ]; then
     wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb ; sudo dpkg -i google-chrome-stable_current_i386.deb ;

else
     wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb ; sudo dpkg -i google-chrome-stable_current_amd64.deb ;
fi
 
echo "
Navegador Google Chrome Instalado com sucesso
"

}

function instalacaoTeamViewer(){

	#cria o arquivo de log
	touch log.txt

	#cria a pasta onde vai ser guardado os pacotes
	if [ ! -d "downloads" ]; then
    	mkdir "downloads"
	fi    

	#inicializa a variavel error em 0
	errors="0"

	#Setamos o user agent
	userAgent="Mozilla/5.0 (X11; Debian Stretch; Linux x86_64; rv:40.0) Gecko/20100101 Firefox/52.0"


	clear
	echo "
	Instalando o TeamViewer
	Para Cancelar a instalação pressione o CTRL + C
	"
	#Startando o download TeamViewer
	dowloadSourcePage "${links[0]}" "$userAgent";
	#Procura o link para fazer download do TeamViewer
	TeamViewer=$(sed -n '/teamviewer_i386.deb/{s/^.*href="\([^"]*\).*/\1/p}' file.html)
	#Faz o download
	response=$(downloadPackage "$TeamViewer" "TeamViewer" "0");
	#Checa o response
	if [ $response -eq "1" ]; then errors=$((errors + "1")); fi;

		echo "
			TeamViewer Instalado com sucesso
		"
}
########### INSTALACAO PACOTES EDUCACIONAIS ########################

function instalacaoPacotesEducacionais()
{

clear
echo "
Instalando pacotes Educacionais...
Para Cancelar a instalação pressione CTRL + C
"
apt-get install anagramarama blinken khangman klettres ktouch kturtle kwordquiz childsplay childsplay-alphabet-sounds-pt gcompris gcompris-sound-ptbr glchess gweled kbattleship kblackbox klickety konquest klines kmahjongg kpat pingus lmemory junior-puzzle xgalaga pinta tuxpaint tuxpaint-plugins-default tuxpaint-stamps-default googleearth-package inkscape -y 

echo "
Pacotes Educacionais Instalados com sucesso...
"
}


############### Menu Extra ###############################

function menuExtra()
{
 
clear
echo "Escolha qual Pacote instalar: 
1 - TLP Gerenciador de energia (Obs.: SOMENTE PARA NOTEBOOKS, ULTRABOOKS OU NETBOOKS)
2 - Navegador Google Chrome
3 - Instalar TeamViewer
4 - Pacotes Educacionais
5 - Retornar ao Menu Principal"	
 
read OPCAOEXTRA	

   case $OPCAOEXTRA in
                
    1) instalacoTLP;;
    2) instalacaoChrome;;
	3) instalacaoTeamViewer;;
    4) instalacaoPacotesEducacionais;;
    5) MenuPrincipal;;
    *) echo "Opcao Invalida...";; 	
   esac 

}


################################################## EXECUCAO DO SCRIPT ###########################################

if [ $USER = "root" ] ## Verifica se o usuario é root
then
clear
MenuPrincipal

else

echo "
Voce Precisa ser root para executar esse script
"

fi

exit
