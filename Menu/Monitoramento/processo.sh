#!/bin/bash
DATA=`date +%d/%m/%Y`
data=`date +%H:%M:%S`
hos=`hostname -I`
ps aux >> Relatorio_de_Processo_$DATA_as_$data.txt
