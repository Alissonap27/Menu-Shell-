#!/bin/bash
hos=`hostname -I`
DATA=`date +%d/%m/%Y`
data=`date +%H:%M:%S`
cat /proc/meminfo >> Relatorio_de_Memoria_$DATA_as_$data.txt
