#!/bin/bash
clear
mn=1
USER=`hostname`
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE MONITORAMENTO " 6 50
while test ${#mn} -gt 0
do
function monitoramento {
mn=$(dialog --stdout --title 'PROGRAMA DE MONITORAMENTO' --menu "ESCOLHA UMA OPCAO" 0 0 0 1 'IPs' \2 'Portas' \3 'Servicos' \4 'Historico' \5 'Agendamento' \6 'Lista de Agenda' \7 'Configuracao de Agendamento')

if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa Monitoramento' 5 40
clear
exit 0
fi
}

monitoramento
DATA=`date +%d/%m/%Y`
data=`date +%H:%M:%S`
HOST=$(echo `hostname -I`)
case $mn in

1)
#primeira opcao do menu aonde vc coloca o ip para ser monitorado atraves do 
#ping
dialog --msgbox 'IPs' 0 0
ho=$(dialog --stdout --nocancel --title 'IPs' --inputbox 'Diga o host para ser monitorado' 0 0 )
ping -c2 $ho > pinga.txt
if [ $? -eq 0 ]
then
dialog --textbox pinga.txt 0 0
h=`echo "Monitoramento do Ip ($ho) em $DATA as $data" >> historico.txt`
elif [ `cat pinga.txt | wc -l` -gt 0 ]
then
dialog --textbox pinga.txt 0 0
h=`echo "Monitoramento do Ip ($ho) em $DATA as $data" >> historico.txt`
else
dialog --msgbox 'Host Não reconhecido' 0 0
fi 
rm pinga.txt 
;;
2)
#segunda opcao aonde vc poem as portas para serem monitoradas atraves do nmap
#Vc tera uma lista de ips que são os de via ssh + o ip da propria maquina
#para esse monitoramento
dialog --msgbox 'Portas' 0 0
echo -e "$HOST\n`who | cut -d")" -f1 | cut -d"(" -f2 | cut -d":" -f2 | awk '{if (($1) > "0") print}'`" | nl > morr.txt
mn6=$(dialog --stdout --nocancel --menu "Escolha a Opcao" 0 0 0 `cat morr.txt`)
hops=$(cat morr.txt | sed -n $mn6' p;' |  awk '{print $2}')  
ho=$(dialog --stdout --nocancel --title 'Portas' --inputbox 'Diga a porta para ser monitorado' 0 0 )
sudo rm morr.txt
dialog --msgbox "$hops" 0 0
sudo nmap -sT -sU -p $ho $hops > nmapa.txt
if [ $? -eq 0 ]
then
dialog --textbox nmapa.txt 0 0 
rm nmapa.txt
sleep 3
h=`echo "Monitoramento das portas ($ho) em $DATA as $data" >> historico.txt`
fi
;;
3)
#terceira opcao do menu aonde existe 3 pequenos programas
op2="1 Processo 2 Memoria 3 Rede"
mn2=$(dialog --stdout --menu "ESCOLHA UMA OPCAO" 0 0 0 $op2)

if [ "${#mn}" -eq "0" ]
	then
dialog --msgbox 'Voltando ao menu' 5 40
	else
case $mn2 in
1)
#o primeiro lista os processos
ps aux >> aux.txt
dialog --textbox aux.txt 0 0
rm aux.txt
;;
2)
#o segundo mostras a quantidade de memoria usada pelos processos em execucao
cat /proc/meminfo > mem.txt
dialog --textbox mem.txt 0 0
rm mem.txt
;;
3)
#o terceiro mostra sua interface
ifconfig > ifc.txt
dialog --textbox ifc.txt 0 0
rm ifc.txt
;;
	esac
op2=$(echo "Processo\Memoria\Rede\ " | cut -d'\' -f"$mn2")
h=`echo "Utilizado o serviço ($op2) do ip ($HOST) em $DATA as $data" >> historico.txt`
fi
;;
4)
#A quarta opcao do menu mostra o historico
dialog --msgbox 'Historico' 0 0
texto=`cat historico.txt | nl`
dialog --msgbox "$texto" 0 0
;;
5)
#A quinta opcao e a parte do agentamento aonde vc coloca minutos horas dias semanas etc, e tambem o usuario e o programa que deseja adicionar ao cron
cd Monitoramento
dialog --msgbox 'Agendamento' 0 0

for (( i=1; i<6; i++ ))
do
da=`cat data"$i".txt` 
es=$(dialog --stdout --menu "`cat data.txt | sed -n $i' p;'`" 0 0 0 $da)
if [ "${#es}" -eq "0" ]
then
dialog --msgbox 'Voltando ao Menu' 5 40
i=8
else
echo $es | sed 's/T/*/g' | tr -s '\n' ' ' >> result.txt
fi
done
if [ $i -lt 7 ]
then
grep /home/ /etc/passwd | cut -d: -f1 | cut -d "g" -f2 > Usa.txt
mn4=$(dialog --stdout --nocancel --title "USUARIOS" --menu 'Escolha uma Opcao' 0 0 0 `cat Usa.txt | nl`)
USER1=$(cat Usa.txt | tr -s ' ' '\n' | awk 'NF>0' | sed -n $mn4' p;')
echo "$USER1" | tr -s '\n' ' ' >> result.txt  
a=`ls | grep .sh | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0' | nl > b.txt`
mn5=$(dialog --stdout --colors --title "\Z1Programas" --menu 'Escolha uma Opcao' 0 0 0 `cat b.txt`)
if [ "${#mn5}" -eq "0" ]
then dialog --msgbox 'voltando ao Menu' 0 0
else
local=$(cat b.txt | sed -n $mn5' p;'| cut -d' ' -f6 | tr '\t ' '.' | cut -d'.' -f2)
local2=$(sudo find / -iname $local.sh | rev | cut -d'/' -f2-10 | rev | head -n 1 >> result.txt)
sudo echo "`cat result.txt`/$local.sh">> /etc/crontab
dialog --msgbox "Agendamento Feito" 0 0
fi
fi
rm result.txt
rm Usa.txt
cd -
;;
6)
#a sexta opcao lista os programas em agendamento
a=$(cat /etc/crontab | sed -n '16,100p' | awk 'NF>0' | nl)
dialog --msgbox "$a" 0 0
;;
7)
#a setima  opcao muda as portas que vao ser usadas pelo nmap no agendamento
#e tambem o ip que vai ser usado junto ao ping no monitoramento
cd Monitoramento
mn8=$(dialog --stdout --nocancel --menu "Lista" 0 0 0 1 "Portas" 2 "Ip")
case $mn8 in
1)
lin1=$(cat portas.sh | sed -n '5p')
aac=$(dialog --stdout --title "Porta:$lin1" --inputbox "Escolha a nova" 0 0 )
if [ $? -eq 0 ]
then
cat portas.sh | sed -e "s;"$lin1";"PORTA=$aac";g" > teste.txt
cat teste.txt > portas.sh
rm teste.txt
fi
;;
2)
lin1=$(cat ips.sh | sed -n '5p')
aac=$(dialog --stdout --title "IP:$lin1" --inputbox "Escolha a nova" 0 0 )
if [ $? -eq 0 ]
then
cat ips.sh | sed -e "s;"$lin1";"Ip=$aac";g" > teste.txt
cat teste.txt > ips.sh
rm teste.txt
fi
esac
;;
esac
done
