#!/bin/bash
function found_user_help () {
echo "

Справка:
Для выхода в меню нажмите --quit или -q
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

	echo "Введите имя группы или часть имени (Выход -q, справка -h)"
	# проверка на пустой ввод
	while read input_name 
	do
		input_len=${#input_name}
		if [ $input_len -eq 0 ] ; then
			printf "Вы ввели пустую строку!\nВведите имя группы или часть имени (Выход -q, справка -h)\n"
		else break;
		fi
	done

	case $input_name in
	*[[:space:]]*)
		echo "Имена нужно вводить по одному!"
		continue;;
	"--help"|"-h"*)
			found_user_help
			continue;;
	"--quit"|"-q")
			echo "---------------------------------------"
			exit 0;;
	*);;
	esac

	#поиск групп с именем, начинающимся на input_name
	groupnames="$(grep -i ^$input_name  /etc/group )"
	len=${#groupnames}
	# если что-то найдено
	tmp_f="$(mktemp)"
	if [ $len -ne 0  ] ; then
		while IFS=: read name password GID oter; do
			printf "Имя группы $name\n GID= $GID \n" >> $tmp_f
			participants="$(lid -g $name)"
			if [ ${#participants} -ne 0 ] ; then
				echo " Пользователи группы:" >> $tmp_f
				for member in $participants
				do
					echo " $member" >> $tmp_f
				done
				printf "\n" >> $tmp_f
			else printf " Нет пользователей в группе.\n\n" >> $tmp_f
			fi
		done <<< "$groupnames"
		less -XFR $tmp_f
	else echo "Групп не найдено."	
	fi
	rm $tmp_f

	MICRO_LOOP=1

	while [[ $MICRO_LOOP -eq 1 ]]; do
		read -p  "Повторить?(y/n) " response

		case $response in
			[Nn]*)
				echo "---------------------------------------"
				exit 0;;
			[Yy]*)
				TOTAL_LOOP=1
				break;;
		"--help"|"-h")
				found_user_help
				continue;;
		"--quit"|"-q")
				exit 0;;
				*)
				echo "Введите y/n"
		esac

	done

done 

echo "---------------------------------------"
