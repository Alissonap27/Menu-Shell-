#!/bin/bash
clear
#INicio
dialog --msgbox "Bem Vindo Ao Programa LISTA" 6 35

#Laço
menu=1
while test ${#menu} -gt 0
do

#Menu
menu=$(dialog --stdout --title 'LISTA' --menu " ESCOLHA UMA OPCAO " 0 0 0 \
1 'Programas Interativos' 2 'Programas de Agendamento' 3 'Agendados' 4 'Txt' 5 'Login' 6 'Usuarios' 7 'Shells' 8 'Usuarios via ssh')
#Saida
if [ "${#menu}" -eq "0" ]
then
#Mensagem de Saida
dialog --msgbox 'Saindo do Programa LISTA' 6 35
clear
exit 0
fi

#Opcoes do Menu
case $menu in
1)
a=$(ls | grep .sh | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0' | nl)
dialog --msgbox "$a" 0 0
;;
2)
cd Monitoramento
a=$(ls | grep .sh | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0' | nl )
dialog --msgbox "$a" 0 0
cd -
;;
3)
cd Monitoramento
a=$(cat /etc/crontab | sed -n '16,100p' | awk 'NF>0' | nl)
dialog --msgbox "$a" 0 0
cd -
;;
4)
a=`ls | grep .txt | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0'`
cd Monitoramento
b=$(echo -e "$a\n`ls | grep .txt | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0'`" | nl)
dialog --msgbox "$b" 0 0
cd -
;;
5)
a=$(cat lo.txt)
dialog --msgbox "$a" 0 0
;;
6)
a=$(grep /home/ /etc/passwd | cut -d: -f1 | cut -d "g" -f2 | tr ' ' '\n'| awk 'NF>0' | nl)
dialog --msgbox "$a" 0 0
;;
7)
a=$(cat /etc/shells | cut -d "#" -f1 | awk 'NF>0' | nl)
dialog --msgbox "$a" 0 0
;;
8)
a=$(who | awk '{print $1,$5}' | nl)
dialog --msgbox "$a" 0 0
;;
esac
done

