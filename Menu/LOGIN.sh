#!/bin/bash
clear
mn=1
USER=`hostname`
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE LOGINS " 6 50
while test ${#mn} -gt 0
do
function loginssh {
mn=$(dialog --stdout --title 'PROGRAMA PARA LOGINS' --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 'Entrar em um login diferente' 2 'Entrar login' 3 'Listar logins')

if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa De Login' 5 35
clear
exit 0
fi
}
loginssh

case $mn in
1)
lo=$(dialog --stdout --nocancel --inputbox 'Diga o Login' 0 0 )
ho=$(dialog --stdout --nocancel --inputbox 'Diga o host' 0 0 )

ssh $lo@$ho && echo "$lo@$ho" >> lo.txt
if [ $? -eq 0 ]
then
a=`cat lo.txt | sort | uniq | awk 'NF>0'`
echo "$a" > lo.txt
else
sleep 2
dialog --msgbox 'Login Mal Sucedido' 0 0
fi
;;
2)b=`cat lo.txt | nl`
escolha=$(dialog --stdout --menu 'ESCOLHA UM LOGIN' 0 0 0 \
$b)
if [ "${#escolha}" -eq "0" ]
then
dialog --infobox 'Voltando' 0 0
else
b=`cat lo.txt | grep -n ^ | grep ^$escolha | cut -d':' -f2`
dialog --msgbox $b 0 0
sudo -u $USER ssh $b
clear
exit 0
fi 
;;
3)
dialog --title 'LOGINS' --textbox lo.txt 0 0 
;;
esac
done
