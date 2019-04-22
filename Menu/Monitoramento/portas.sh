#!/bin/bash
DATA=`date +%d/%m/%Y`
data=`date +%H:%M:%S`
hos=`hostname -I`
PORTA=54,22,45,11,4
nmap -p $PORTA $hos >> Relatorio_de_Portas_$DATA_as_$data.txt

