#!/bin/bash
clear
mn=1
USER=`hostname`
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE BACKUPS " 6 50
#laco do programa para voltar ao inicio quando precisar
while test ${#mn} -gt 0
do
#funcao dos diretorios que vao estar os backups
function diretorios {
if [ "$muda" = "origem" ]
then
origem=$(cat origem.txt)
elif [ "$muda" = "destino" ]
then
destino=$(cat destino.txt)
fi
compacta="$origem"/
receber="$destino"/
cd Monitoramento
lin1=$(cat backups.sh | sed -n '7p')
lin2=$(cat backups.sh | sed -n '8p')
cd -
}
#funcao do menu inicial do programa
function backssh {
mn=$(dialog --stdout --title 'PROGRAMA PARA BACKUPS' --menu "ESCOLHA UMA OPCAO" 0 0 0 1 'Backup' 2 'Troca local de Agendamento' 3 'troca local do backup' 4 'listar')

if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa Backup' 5 30
clear
exit 0
fi
}

backssh
#variaveis que compoem data, nome do usuario, e tambem a origem e destino do backup
DATA=`date +%Y-%m-%d-%H.%M.%S`
a=`hostname`
er=$(cat origem.txt | wc -l)
if [ "$er" -eq "0" ]
then
origem=/home/`hostname`/Documentos
else
origem=$(cat origem.txt)
fi
er=$(cat destino.txt | wc -l)
if [ "$er" -eq "0" ]
then
destino=/home/`hostname`/Documentos
else
destino=$(cat destino.txt)
fi
#case das opcao do menu sendo a primeira a opcao do backup cadastrado e não
case $mn in
1)mn4=$(dialog --stdout --title 'PROGRAMA PARA BACKUPS' --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 'Cadastrado')

if [ "${#mn4}" -eq "0" ]
then
dialog --msgbox 'Voltando ao Menu' 5 30
fi
case $mn4 in
1)
#possue uma lista e não precisa ser digitado por isso
true=`cat lo.txt `
if [ ${#true} -eq 0 ]
then
dialog --msgbox 'falta usuarios cadastrado use o programa LOGIN ou CHAVE para adicionar um usuario' 0 0
d=0
else
d=1
b=`cat lo.txt | nl`
escolha=$(dialog --stdout --menu 'ESCOLHA UM LOCAL' 0 0 0 \
$b)
if [ "${#escolha}" -eq "0" ]
then
dialog --msgbox 'voltando ao menu' 0 0
else
c=`cat lo.txt | grep -n ^ | grep ^$escolha | cut -d':' -f2 | cut -d '@' -f1`
b=`cat lo.txt | grep -n ^ | grep ^$escolha | cut -d':' -f2`
fi
fi
;;
2)
#case 1 opcao 2 não cadastrado aonde precisa digitar o login e host
receber=$(dialog --stdout --nocancel --inputbox 'Diga o Login' 0 0 )
b=$(dialog --stdout --nocancel --inputbox 'Diga um host' 0 0 )
d=1
esac
#chama diretorios que contem os locais e pergunta se vc tem ctz
#caso sim ele comeca o backup
diretorios
if [ "$d" -eq 1 ]
then
dialog --yesno  "Voce Tem certeza?" 0 0 
if [ "$?" = "0" ]
then
    (echo 10; sleep 1; echo 30; sleep 1; echo 50; sleep 1; echo 70; sleep 1; echo 100) | dialog --gauge 'Aguarde... \n
Fazendo o Backup' 8 70 0
tar -zcvf www-$DATA.tar.gz "$compacta" 
sudo -u $USER scp www-$DATA.tar.gz "$b":"$receber"
if [ $? -eq 0 ]
then
rm -f www-$DATA.tar.gz
dialog --msgbox "Backup feito com Sucesso" 8 40
dialog --msgbox "Diretorio que foi feito backup: $compacta" 8 40
dialog --msgbox "Diretorio aonde foi enviado: $receber" 8 40
sudo rm ba1.txt
sudo rm ba2.txt
else
rm -f www-$DATA.tar.gz
dialog --msgbox "Erro ao fazer o backup" 5 40

fi
fi
fi
;;
2)
#Alterar locais dos backups para os agendamentos, que vao ser inserido em cron
cd Monitoramento
lin1=$(cat backups.sh | sed -n '7p')
lin2=$(cat backups.sh | sed -n '8p')
aac=$(dialog --stdout --title "local origem atual:$lin1" --inputbox "Escolha o local de origem" 0 0 )
aad=$(dialog --stdout --title "local destino atual:$lin2" --inputbox "Escolha o local de destino" 0 0 )
cat backups.sh | sed -e "s;"$lin1";"compacta=$aac";g" | sed -e "s;"$lin2";"receber=$aad";g" > teste.txt
cat teste.txt > backups.sh
rm teste.txt
cd -
;;
3)
#altera os locais dos backups
mn9=$(dialog --stdout --nocancel --menu "Altere" 0 0 0 1 "Origem" 2 "Destino" )
if [ $mn9 = 1 ]
then
muda=origem
else
muda=destino
fi
#opcao de personalização aonde pode ser usado locais ja prontos
#e locais que precisam ser digitados
mn7=$(dialog --stdout --nocancel --menu "Opção pasta $muda" 0 0 0 1 "Personalizar" 2 "Lista" )
case $mn7 in
1)
pasta=$(dialog --stdout --nocancel --inputbox "Informe a pasta de $muda desejada" 0 0 )
muda1=$pasta
echo "$muda1" > $muda.txt
diretorios muda
;;
2)
#locais que ja estao prontos em uma lista
mn8=$(dialog --stdout --nocancel --menu "Lista" 0 0 0 1 "Downloads" 2 "Documentos" 3 "Música" 4 "Vídeos" 5 "Imagens")
r=/home/`hostname`/
muda1=$(echo ""$r"Downloads-"$r"Documentos-"$r"Música-"$r"Vídeos-"$r"Imagens" | cut -d'-' -f$mn8)
diretorios muda
echo "$muda1" > $muda.txt
esac
;;
4)
#lista locais de Backups tando do agendamento quando do programa interativo
diretorios
dialog --msgbox "Backups:   Compactado:$compacta    Recebe:$receber     Agendamento:   $lin1       $lin2 " 0 0
esac
done
