#! /bin/bash
clear
mn=1
#variavel que contem o nome do usuario
USER=$(hostname)
#Mensagem de Bem Vindo do programa com dialog
dialog --msgbox " BEM VINDO "$USER" AO PROGRAMA DE USUARIOS " 6 50
#Um laço que faz o menu inicial do programa se repetir
while test ${#mn} -gt 0
do

#funcao dos nomes dos usuarios
function nomeuser {
#pega os nomes dos usuarios utilizando grep em /etc/passwd que contem a informação depois filtra o resultado com o cut e da um awk para tirar linhas brancas caso houver depois da um grep com a variavel var que contem o nome em parcial e da um nl pra pegar o numero de linhas.
var2=$(grep /home/ /etc/passwd | cut -d: -f1 | cut -d "g" -f2 | tr ' ' '\n'| awk 'NF>0' | grep "$var" | nl)
#Menu
escolha=$(dialog --stdout --nocancel --menu 'ESCOLHA UM LOGIN' 0 0 0 \
$var2)
#Pega a linha aonde contem o nome utilizando o sed -n aonde pega a linha com o numero indicado que nesse caso sai do menu.
var2=$(grep /home/ /etc/passwd | cut -d: -f1 | cut -d "g" -f2 | tr ' ' '\n'| awk 'NF>0' | grep "$var" | sed -n $escolha' p;')
#limpa var que contem o nome em parcial em algumas opcoes
unset var
}

#Funcao do menu inicial do programa
function usuario {
mn=$(dialog --stdout --title 'PROGRAMA DE USUARIOS' --menu "ESCOLHA UMA OPCAO" 0 0 0 \
1 'Adicionar usuarios' \2 'Remover usuarios' \3 'Editar usuario' \4 'Listar usuarios' \5 'Buscar usuário')
#O escape caso a opcao escolhida do menu foi a de cancelar
#ira testar a variavel mn se n ouver nada nela entao ele sai do #programa --- LINHA 18
if [ "${#mn}" -eq "0" ]
then
dialog --msgbox 'Saindo do programa Usuario' 5 30
#limpa a tela antes de sair do programa 
clear
#sai
exit 0
fi
}
#chamada da funcao usuario que vai para o menu
usuario
#entrada do case com a opcao que sai do menu sendo que o menu
#ira retorna numeros de acordo com o escolhido
#se o usuario escolher cancelar ele nao entra no case
case $mn in
#Mensagem com a Primeira opcao
1) dialog --msgbox 'Processo de adicao' 0 0
#Variavel que vai adicionar o nome do usuario
add1=$(dialog --stdout --nocancel --inputbox 'Diga o nome do usuario para adicionar' 0 0 )
#variavel que vai adicionar a senha do usuario
pass1=$(dialog --stdout --nocancel --inputbox 'Diga a senha' 0 0 )
#Variavel que adiciona a senha repetida
pass2=$(dialog --stdout --nocancel --inputbox 'Repita a Senha' 0 0 )
#Comparacao se as 2 senhas sao iguais caso sim entao ele vai
#adicionar o usuario se não houver outro erro
if [ $pass1 = $pass2 ]
then
#Comando para adicionar o usuario ja com senha por causa do parametro p
sudo useradd -s /bin/bash -m -p 1 $add1
sudo usermod -p $(openssl passwd -1 $pass1) $add1
#pega o resultado do comando de cima 0 para caso for correto o comando
if [ $? -eq 0 ]
#caso comando for correto adiciona a msg de bem sucedido
then
dialog --msgbox "  Adicao de  $add1  Bem Sucedida  " 0 0
#caso comando for incorreto vai para o else e mostra a msg de erro
else
dialog --msgbox "  Erro ao adicionar  $add1   " 0 0
#fecha o segundo if do resultado do comando
fi
else
#o else do primeiro if desse case apresenta a msg de senha diferentes
dialog --msgbox "As senha são diferentes" 0 0
#fecha o primeiro if das senhas
fi
;;
2)
#segundo case do processo de remocao e ja mostra uma msg abaixo
dialog --msgbox 'Processo de remocao' 0 0
#variavel rm1 recebe o nome do usuario pra ser removido
rm1=$(dialog --stdout --nocancel --inputbox 'Diga o nome do usuario para remover' 0 0 )
#remove caso não haja algum erro o usuario descrito na variavel rm1
sudo userdel $rm1
#Pega o resultado do comando e ve se tem erro
if [ $? -eq 0 ]
then
#Sem erro, da a msg de remocao bem sucedida
dialog --msgbox "  remocao $rm1 Bem Sucedida  " 0 0
#caso não
else
#da erro ao remover
dialog --msgbox "  erro ao remover $rm1  " 0 0
#fecha o if
fi
;;
3)
#Terceira opcao, o processo de edicao, que ja inclui um menu na
#variavel mn2 
mn2=$(dialog --stdout --title 'Processo de edicao' --menu "ESCOLHA UMA OPCAO" 0 0 0 \1 'Mudar Login' \2 'Mudar Senha' \3 'Mudar interpretador' )
#if para tratar a opcao cancelar no menu, que diz que volta ao menu
#caso escolhido cancelar for escolhido e semelhante ao da linha 19
#a diferenca e o nome da variavel e esse retorna ao menu em vez de sair
if [ "${#mn2}" -eq "0" ]
then
dialog --msgbox 'voltando ao menu' 0 0
fi
#Abre um case com opcao da saida da variavel mn2
case $mn2 in
1)
#a variavel ed1 vai receber o nome do usuario para editar
#e a variavel ed2 vai recever o nome novo do usuario
#&& caso o primeiro comando for correto vai para o segundo
nomeuser
ed2=$(dialog --stdout --nocancel --inputbox 'Diga o novo nome de usuario' 0 0 )
#o comando de troca e acionado editando a variavel ed1 substituindo
#por ed2
sudo usermod -l $ed2 $var2

#testa o comando
if [ $? -eq 0 ]
#caso o comando esteja correto manda uma msg de correto e outra
#com o nome novo do usuario
then
sudo usermod -d /home/$ed2 $ed2
dialog --msgbox "Usuario $var2 Editado Com Sucesso  " 0 0
dialog --msgbox "O Novo nome de Usuario e : $ed2 " 0 0
#caso contrario manda uma msg de erro
else
dialog --msgbox "  erro ao editar $var2  " 0 0
#fecha o case do teste do comando
fi
;;
2)
#segundo case da opcao editar comeca com um nome de usuario
nomeuser
ed2=$(dialog --stdout --nocancel --inputbox 'Diga a nova Senha' 0 0 )
ed3=$(dialog --stdout --nocancel --inputbox 'Regedite a Senha' 0 0 )
if [ $ed2 = $ed3 ]
then
sudo usermod -p $(openssl passwd -1 $ed2) $var2
if [ $? -eq 0 ]
then
dialog --msgbox "Senha do Usuario $var2 Editada Com Sucesso  " 0 0
else
dialog --msgbox "Erro ao editar senha de: $var2  " 0 0
fi
else
dialog --msgbox 'As senhas nao sao iguais' 0 0
fi
;;
3)
#Terceira opcao do case de edicao
#variavel que lista os shells instalados, cut corta os dados para
#apresenta so os shells e awk retira as linha em branco caso haja
#nl poem numeracao pra ficar pratico ao fazer o menu
ed3=$(cat /etc/shells | cut -d "#" -f1 | awk 'NF>0' | nl)
#variavel inte recebe o resultado das opcao do menu
#que a variavel ed3 acabo criando
inte=$(dialog --stdout --menu "Diga Opcao do menu" 0 0 0 $ed3)
#if para opcao cancelar caso colocada volta ao menu
if [ "${#inte}" -eq "0" ]
then
dialog --msgbox 'Voltando ao menu' 5 30
else
#variavel varia que pega as lista do shell e depois da um sed
#que escolhe a linha deseja, utilizando a variavel
#inte do menu para fazer essa escolha pelo numero da saida dela
varia=$(cat /etc/shells | cut -d "#" -f1 | awk 'NF>0' | sed -n $inte' p;')
nomeuser
#usa o comando usermod com parametro s para mudar o shell do usuario
#escolhido pelas opcoes acima
sudo usermod -s "$varia" "$var2"
fi
esac
;;
#Opção de listagem de usuarios, informando todos usuarios do sistema
4)
dialog --msgbox ' Processo de listagem de usuarios ' 0 0
var2=$(grep /home/ /etc/passwd | cut -d: -f1 | cut -d "g" -f2 | tr ' ' '\n'| awk 'NF>0' | grep "$var" | nl)
dialog --msgbox "$var2" 0 0
;;
5)
#Opção para procurar por nome completo ou parte do nome do usuario
#Informa nome, diretório padrão e interpretador
var=$(dialog --stdout --nocancel --inputbox 'Informe o nome de usuario ou parte dele' 0 0 )
nomeuser $var
var3=$(cat /etc/passwd | grep -w $var2 | cut -d "/" -f2-3 | cut -d ":" -f1)
var4=$(cat /etc/passwd | grep -w $var2 | cut -d ":" -f7)
#echo $SHELL
dialog --msgbox "Nome:$var2  Diretorio:$var3  Interpretador:$var4" 0 0
;;
esac
done

