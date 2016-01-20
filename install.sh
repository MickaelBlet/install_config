#!/bin/bash

function install_zsh()
{
	cp -r install/config ~/.myconfig
}

function print_menu()
{
	local index=$1

	printf "\n\r"
	if [[ $index == "1" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	printf "1. ZSH + PROMPT + VIM\n\r"
	if [[ $index == "2" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	printf "2. ZSH + PROMPT\n\r"
	if [[ $index == "3" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	printf "3. PROMPT\n\r"
	if [[ $index == "4" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	printf "4. VIM\n\r"
}

echo ""
cols=`echo "$(tput cols)"`
cols1=`echo "$(tput cols)/2+14/2"|bc`
cols2=`echo "$(tput cols)/2-14/2"|bc`
result=`echo "$cols1+$cols2"|bc`
if [ $result != $cols ]; then
	cols1=`echo "$cols1+1"|bc`
fi
printf "\033[48;5;244m\033[38;5;231m"
printf "%*s%*s\n\r" $cols1 "MBLET CONFIGS" $cols2 ""
printf "\033[38;5;226m\033[7m"
printf "%*s%*s" $cols1 "INSTALL SPEED" $cols2 ""
printf "\033[0m\n\r"
printf "\n\r1. ZSH + PROMPT + VIM\n\r2. ZSH + PROMPT\n\r3. PROMPT\n\r4. VIM\n\r\n\rChoose your option : "
read -r -n 1 C
case $C in
	1) printf "\r\033[K\n";;
	2) echo "PROMPT";;
	3) echo "ZSH";;
	4) echo "VIM";;
	$'\x1b')
		read -srn1 -t 1 D
		if [[ "$D" == "[" ]]; then
			read -rsn1 -t 1 E
			case $E in
				A) print_menu 1;;
				B) printf "Down\n";;
				C) printf "Right\n";;
				D) printf "Left\n";;
			esac
		fi;;
	$'') echo enter;;
	*) echo test;;
esac
#tput up
#tput up
#tput up
#tput up
#printf "\033[K\n"
#printf "\033[K\n"
#printf "\033[K"
#tput up
#tput up
#printf "\033[48;5;118m%*s\033[0m\n" $cols ""
#printf "\033[48;5;118m%*s\033[0m\n" $cols ""
#printf "\033[48;5;118m%*s\033[0m\n" $cols ""
#echo ""
