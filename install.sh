#!/bin/bash

cols=`echo "$(tput cols)"`

function install_zsh()
{
	cp -r install/config ~/.myconfig
}

function print_middle()
{
	local _str=`echo "$*"`
	local _len="${#_str}"
	local _cols=`echo "$(tput cols)/2-$_len/2"|bc`

	printf "%*s" $_cols $_str
}

function print_menu()
{
	local index=$1

	printf "\n\r"
	if [[ $index == "0" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	print_middle "ZSH + PROMPT + VIM\n\r"
	if [[ $index == "1" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	print_middle "ZSH + PROMPT\n\r"
	if [[ $index == "2" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	print_middle "PROMPT\n\r"
	if [[ $index == "3" ]]; then
		printf "\033[7m"
	else
		printf "\033[0m"
	fi
	print_middle "VIM\n\r"
}

clear
echo ""
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

index=0

print_menu $index

while read -r -n 1 C; do
case $C in
	$'\x1b')
		read -srn1 -t 1 D
		if [[ "$D" == "[" ]]; then
			read -rsn1 -t 1 E
			case $E in
				A) index=$(($index - 1));;
				B) index=$(($index + 1));;
				C) index=$(($index + 1));;
				D) index=$(($index - 1));;
			esac
			if [[ $index > "3" ]]; then
				index=3
			fi
			if [[ $index < "0" ]]; then
				index=0
			fi
			printf "\r\033[K"

			tput up
			tput up
			tput up
			tput up
			tput up
			print_menu $index
		fi;;
	*) break
esac
done
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
