#!/bin/bash

clear
mn=1
USER=$(hostname)
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE CHAVES " 6 50
while test ${#mn} -gt 0
do
function chave {
mn=$(dialog --stdout --title 'PROGRAMA CHAVE' --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 'Gerar Chave e criar protecao' \
2 'Permissão para Acessar dispositivos' \
3 'Listar Dispositivos com permissao' \
4 'Configurações -->')

if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa chave' 5 30
clear
exit 0
fi
}

chave
case $mn in
1)
ssh-keygen -t rsa
cd ~/.ssh
cat id_rsa.pub >> sudo -u $USER authorized_keys
rm sudo
chmod 600 authorized_keys
a=`hostname -I`
b=`hostname`
ssh-copy-id -i ~/.ssh/id_rsa.pub $b@$a && cd - && echo "$b@$a" >> lo.txt
sleep 2
dialog --msgbox 'Chave Gerada' 0 0
aa=`cat lo.txt | sort | uniq | awk 'NF>0'`
echo "$aa" > lo.txt
;;
2)
lo=$(dialog --stdout --nocancel --inputbox 'Diga o Login' 0 0 )
ho=$(dialog --stdout --nocancel --inputbox 'Diga o host' 0 0 )

ssh-copy-id -i ~/.ssh/id_rsa.pub "$lo"@"$ho"
if [ $? -eq 0 ]
then
dialog --msgbox 'Permissao concedida' 0 0
echo "$lo@$ho" >> lo.txt
a=`cat lo.txt | sort | uniq | awk 'NF>0'`
echo "$a" > lo.txt

else
dialog --msgbox 'permissao negada' 0 0

fi
;;
3)
dialog --textbox lo.txt 0 0
;;
4)clear
mn3=$(dialog --stdout --title 'PROGRAMA CHAVE' --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 'Erro pedido de autenticação' \
2 'Configurar ssh' \
3 'Configurar sshd')
if [ "${#mn3}" -eq "0" ]
then
mn3=0
fi
case $mn3 in
1)
ssh-add
;;
2)
sudo nano /etc/ssh/ssh_config
;;
3)
sudo nano /etc/ssh/sshd_config
;;
0)dialog --msgbox 'voltando ao menu' 0 0
;;
*)dialog --msgbox 'opcao invalida' 0 0 
esac
;;
*)dialog --msgbox 'opcao invalida' 0 0
esac
done
