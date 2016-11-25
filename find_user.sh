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

	echo "Введите имя пользователя или часть имени"
	# проверка на пустой ввод
	while read input_name 
	do
		input_len=${#input_name}
		if [ $input_len -eq 0 ] ; then
			printf "Вы ввели пустую строку!\nВведите имя пользователя или часть имени\n"
		else break;
		fi
	done

	case $input_name in
		"--help"|"-h")
			found_user_help
			continue
			;;
		"--back"|"-b")
			echo "---------------------------------------"
			exit 0;;
		*);;
	esac

	#поиск пользователей с именем, начинающимся на input_name
	usernames="$(grep -i ^$input_name  /etc/passwd | cut -d: -f1)"
	len=${#usernames}
	# если что-то найдено
	if [ $len -ne 0  ] ; then
	
		for user in $usernames
		do
			lslogins $user
		done
	else
		echo "Пользователей не найдено."
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

