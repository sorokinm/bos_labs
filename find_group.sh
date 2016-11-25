#!/bin/bash
function found_user_help () {
echo "

Справка:
Для выхода в меню нажмите --back или -b
Для вызова справки --help или -h

"
}

echo "---------------------------------------"

if [[ $(whoami) != root ]]; then
	echo "Выполните вход в root"
	echo "---------------------------------------"
	exit 1
fi

TOTAL_LOOP=1
while [[ $TOTAL_LOOP -eq 1 ]]; do

	echo "Введите имя группы или часть имени"
	# проверка на пустой ввод
	while read input_name 
	do
		input_len=${#input_name}
		if [ $input_len -eq 0 ] ; then
			printf "Вы ввели пустую строку!\nВведите имя группы или часть имени\n"
		else break;
		fi
	done

	case $input_name in
	"--help"|"-h"*)
			found_user_help
			continue;;
	"--back"|"-b")
			echo "---------------------------------------"
			exit 0;;
	*);;
	esac

	#поиск групп с именем, начинающимся на input_name
	groupnames="$(grep -i ^$input_name  /etc/group )"
	len=${#groupnames}
	# если что-то найдено
	if [ $len -ne 0  ] ; then
		while IFS=: read name password GID oter; do
			printf "Имя группы $name\n GID= $GID \n"
			participants="$(lid -g $name)"
			if [ ${#participants} -ne 0 ] ; then
				echo " Пользователи группы:"
				for member in $participants
				do
					echo " $member"
				done
				printf "\n"
			else printf "Пользователей не найдено.\n\n"
			fi
		done <<< "$groupnames"
	else echo "Групп не найдено."
	fi

	MICRO_LOOP=1

	while [[ $MICRO_LOOP -eq 1 ]]; do
		read -p  "Повторить?(y/n) " response

		case $response in
			[Nn]*)
				echo "Выход в меню"
				echo "---------------------------------------"
				exit 0;;
			[Yy]*)
				TOTAL_LOOP=1
				break;;
		"--help"|"-h")
				found_user_help
				continue;;
		"--back"|"-b")
				exit 0;;
				*)
				echo "Введите y/n"
		esac

	done

done 

echo "---------------------------------------"
