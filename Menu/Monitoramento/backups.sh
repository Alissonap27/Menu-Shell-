#!/bin/bash
ac=`whoami`
b=`hostname -I`
DATA1=`date +%d/%m/%Y`
data=`date +%H:%M:%S`
DATA=`date +%Y-%m-%d-%H.%M.%S`
compacta=/home/antunes/Downloads
receber=/home/antunes/Downloads


tar -zcvf www-$DATA.tar.gz "$compacta"
scp www-$DATA.tar.gz "$b":"$receber"
echo "Backup feito de (($compacta)) para (($receber)) em $DATA1 as $data do usuario (($ac)) ao usuario (($b))" >> Relatorio_de_Backups.txt
rm -f www-$DATA.tar.gz
