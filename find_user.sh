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

	echo "Введите имя пользователя или часть имени (Выход -q, справка -h)"
	# проверка на пустой ввод
	while read input_name 
	do
		input_len=${#input_name}
		if [ $input_len -eq 0 ] ; then
			printf "Вы ввели пустую строку!\nВведите имя пользователя или часть имени  (Выход -q, справка -h)\n"
		else break;
		fi
	done

	case $input_name in
		"--help"|"-h")
			found_user_help
			continue
			;;
		"--quit"|"-q")
			echo "---------------------------------------"
			exit 0;;
		*);;
	esac

	#поиск пользователей с именем, начинающимся на input_name
	usernames="$(grep -i ^$input_name  /etc/passwd)"
	len=${#usernames}
	# если что-то найдено
	tmp_f="$(mktemp)"
	if [ $len -ne 0  ] ; then
		while IFS=: read name password uid gid info home_folder she; do
			if [ $uid -ge 1000 ] ; then
				echo "Имя пользователя $name" >> $tmp_f
				echo " UID= $uid" >> $tmp_f
				echo " info: $info" >> $tmp_f
				echo " Домашняя папка $home_folder" >> $tmp_f
				echo " Оболочка $she" >> $tmp_f
			fi
		done <<< "$usernames"
		less -XFR $tmp_f
	else echo "Пользователей не найдено."
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

