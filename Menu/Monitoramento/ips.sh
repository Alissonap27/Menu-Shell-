#!/bin/bash
hos=`hostname -I`
DATA=`date +%d/%m/%Y`
data=`date +%H:%M:%S`
Ip=8.8.8.8
ping -c 5 $Ip >> Relatorio_de_Ip_$DATA_as_$data.txt
