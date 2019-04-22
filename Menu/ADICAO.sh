#!/bin/bash
#Script de adição de programas
clear
mn=1
USER=$(hostname)
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE ADICAO" 6 60
#Um laço que faz o menu inicial do programa se repetir
while test ${#mn} -gt 0
do
#Função de inicio do programa com dialogo e lista opções
function adicao {
mn=$(dialog --stdout --title 'PROGRAMA PARA ADICAO' --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 'Criar Programa' \
2 'Lista Programas')

if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa De Adicao' 5 60
clear
exit 0
fi
}
adicao
case $mn in
1)
#Caso 1 para adicionar programas
#Diferencia entre programas de agendamento e programas interativos
mn=$(dialog --stdout --menu "ESCOLHA UMA OPCAO" 0 0 0 1 'Programa de agendamento' 2 'Programas Interativos')
if [ $mn -eq  1 ]
then
cd Monitoramento
fi
#Inicio do dialog de criação
dialog --msgbox 'Bem vindo a criacao de programas' 0 0
nome=$(dialog --stdout --nocancel --inputbox 'Escolha um nome para o programa ex:(nome.sh)' 0 0)
touch -c $nome
if [ $? -eq 0 ]
then
dialog --msgbox "Arquivo $nome criado Com Sucesso  " 0 0
nm=akinome
nm1=`echo $nome | cut -d'.' -f1 | tr [a-z] [A-Z]`
dialog --yesno  "Voce Que Por um menu ?" 0 0 \
	        && cat adicao$mn.txt | sed 's/'"$nm"'/'"$nm1"'/' >> $nome
dialog --msgbox "Entrando no Setup do programa: $nm1" 0 0
sudo chmod +x $nome
nano $nome
else
dialog --msgbox "Erro ao criar : $nome  " 0 0
fi
if [ $mn -eq  1 ]
then
cd -
fi
;;
2)

mn2=$(dialog --stdout --menu "ESCOLHA UMA OPCAO" 0 0 0 1 'Programa de agendamento' 2 'Programas Interativos')
if [ $mn2 -eq  1 ]
then
cd Monitoramento
a=`ls | grep .sh | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0' | nl`
dialog --msgbox "$a" 0 0
else
a=`ls | grep .sh | cut -d'~' -f2 | cut -d'.' -f1 | awk 'NF>0' | nl`
dialog --msgbox "$a" 0 0
fi
esac
done
