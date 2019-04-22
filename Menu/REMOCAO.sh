#!/bin/bash

clear
mn=1
USER=$(hostname)
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE REMOCAO" 6 60
while test ${#mn} -gt 0
do
function remocao {
mn=$(dialog --stdout --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 "Remover Agendamento" 2 "Remover Programas/txt")

if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa De remocao' 5 60
clear
exit 0
fi
}
remocao
case $mn in
1)
#Opcao para remover os agendamentos
mn2=$(dialog --stdout --nocancel --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 "Remover Todos" 2 "Remover Seletivo" 3 "Lista De Agendado")
case $mn2 in
1)
#remove tudo
sudo cat RemoveTudo.txt > /etc/crontab
dialog --msgbox 'Remocao Feita' 0 0
;;
2)
#remove seletivamente os programas agendados
a=$(cat /etc/crontab | sed -n '16,100p' | tr ' ' '.' | awk 'NF>0' | nl)
if [ "${#a}" -eq "0" ]
then
dialog --msgbox "Nao Tem nada agendado" 0 0
else
mn6=$(dialog --stdout --nocancel --menu 'ESCOLHA UMA OPCAO' 0 0 0 \
$a)
mn6=$(($mn6 + 15))
if [ $mn6 -ge 16 ]
then 
cat /etc/crontab > rmparcial.txt
sudo cat rmparcial.txt | sed "$mn6"d > /etc/crontab
dialog --msgbox 'Remocao Feita' 0 0
rm rmparcial.txt
fi
fi
;;
3)
#lista os programas agendados
a=$(cat /etc/crontab | sed -n '16,100p' | awk 'NF>0' | nl)
dialog --msgbox "$a" 0 0
;;
esac
;;
2)
#Segunda opcao aonde pode remover os programas e textos
dialog --msgbox 'Bem vindo a remocao de programas' 0 0
mn5=$(dialog --stdout --menu "ESCOLHA UMA OPCAO" 0 0 0 1 'Remocao de Programa de agendamento' 2 'Remocao de Programas Interativos')
if [ $mn5 -eq  1 ]
then
cd Monitoramento
fi
nome=$(dialog --stdout --nocancel --inputbox 'Diga o nome do programa' 0 0)
sudo rm $nome
if [ $? -eq 0 ]
then
dialog --msgbox 'Programa removido' 0 0
else
dialog --msgbox "Erro ao remover: $nome  " 0 0
fi
if [ $mn5 -eq  1 ]
then
cd -
fi
;;
esac
done
