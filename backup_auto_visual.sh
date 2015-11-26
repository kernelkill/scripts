#Autor: Joabe Kachorroski
#Data: 26/05/2015
#Sobre: Programa para fazer backup via conexao automatizada com ssh.
#Versão: 0.1


TITLE="Quality Backup"

SSH=$(zenity --title=" $TITLE - Validar Usuario" \
       --text="Digite o do Usuario: "\
       --entry --height=150 --width=350)           
      [ $? -ne 0 ] && --zenity --text="Esc ou CANCELAR apertado" --error && exit
      
SENHA=$(zenity  --password --title="$TITLE - Validar Senha" )
        
      [ $? -ne 0 ] && --zenity --text="Esc ou CANCELAR apertado" --error && exit  
      
      sshpass -p $SENHA ssh $SSH@10.1.2.192         
     
