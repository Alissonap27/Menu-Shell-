#!/bin/bash
clear
#acha o programa monitoramento e entra na pasta
#depois lista os programas que estao na pasta em um menu
#nesse menu vc pode escolher que tipo de programa que executar
local=`sudo find / -iname MONITORAMENTO.sh | rev | cut -d'/' -f2-10 | rev | head -n 1`
cd "$local"/
dialog --infobox "Iniciando Programas do Local $local" 0 0
sleep 3
mn=1
while test ${#mn} -gt 0
do
a=`ls | grep .sh | cut -d'~' -f2 | cut -d'.' -f1 | grep -v programas | awk 'NF>0' | nl > a.txt`
a=`cat a.txt | sort | uniq | awk 'NF>0'`
echo "$a" > a.txt
b=`cat a.txt`
mn=$(dialog --stdout --colors --title "\Z1Programas" --menu 'Escolha uma Opcao' 0 0 0 \
$b \
0 'SETUP')
if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo ' 0 0
clear
exit 0
fi

if [ $mn -gt 0 ]
then
exe=`cat a.txt | sed -n $mn' p;' | cut -d':' -f2 | cut -d' ' -f6 | tr '\t ' '.' | cut -d'.' -f2`
./"$exe".sh
else
mn2=$(dialog --stdout --colors --title '\Z4Setup' --menu '\Z4Escolha uma Opcao' 0 0 0 \
$b \
0 'SETUP')
if [ "${#mn2}" -eq "0" ]
then
dialog --msgbox 'Voltando Ao Menu ' 0 0
else
if [ $mn2 -gt 0 ]
then
exe=`cat a.txt |  sed -n $mn2' p;'| cut -d':' -f2 | cut -d' ' -f6 | tr '\t ' '.' | cut -d'.' -f2`
nano $exe.sh
else
a=`cd -`
cd $a
nano programas.sh
cd "$local"/
fi
fi
fi
done
