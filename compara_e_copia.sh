#!/bin/sh

#Sao necessarios alterar apenas estas 3(tres) variaveis

origem=/pasta_origem                  #Pasta de origem altere /teste, pelo caminho necessario
dest=/pasta_destino                   #Pasta destino altere /teste2, pelo caminho necessario
arq_comp=/scripts/arq_compara         #Arquivo criado para comparacao entre as duas pasta, altere /scripts/arq_compara, pelo caminho necessario

diff /$origem /$dest | cut -d: -f2 | cut -d" " -f2 > $arq_comp 
#Compara as duas pastas, recorta o que nao interessa e deixa so o nome do arquivo e joga para um arquivo de comparacao que sera lido durante a exec do programa

if test -s $arq_comp                  #Verifica se o arquivo de comparacao esta vazio.
then
while test -s $arq_comp               #Caso nao esteja entra em loop para sincronismo
do
var=`head -1 $arq_comp`               #Le a primeira linha do arq de comparacao e joga para uma variavel temporaria
cp $origem/$var /$dest                #Copia o arquivo que falta da pasta origem para o dest.
sed -i '1d' $arq_comp                 #Elimina a primeira linha que foi lida do arquivo.
echo $var                             #exibe a linha copiada
sleep 1                               #Espera um seg. fique a vontade para comentar esta linha.
done                                  #Fecha o Loop
rm -f $arq_comp                       #apaga arquivo de comparacao, nao ha problema se nao apagar pois sera sobrescrita na proxima exec do programa
echo "Pastas sinconizadas com sucesso!!!" #Mensagem de sucesso, pode ser removida tb
else
echo "Pastas ja sincronizadas!!!"         #caso os arquivos ja estejam sincronizados, exibe esta mensagem
rm -f $arq_comp                           #Apaga arquivo de comparacao temporario
fi
exit
