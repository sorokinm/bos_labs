#!/bin/bash
#изменение пароля
function change_password () {
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
tmp_Users="$(mktemp)"
tmp_FoundUser1="$(mktemp)"
cut -d : -f1 /etc/passwd | cat -n | awk '$1=$1' > $tmp_Users #вывод пользователей из файла etc/passwd в фаил
cat $tmp_Users
GENLOOP=1
while((GENLOOP));do
	LOOP=1
	while((LOOP)); do
		echo "Введите имя пользователя или его порядковый номер"
		read user
	 	case $user in
	        "--help"|"-h"*)
			change_password
			continue;;
	        "--back"|"-b")
			echo "---------------------------------------"
			exit 0;;
	        *);;
	        esac
		grep -w $user $tmp_Users | cut -d' ' -f2 > $tmp_FoundUser1 #поиск указанного пользователя и вывод его в фаил
		Len=$(stat -c%s $tmp_FoundUser1) #количество байтов в файле
		case $Len in
		      0)echo "Такого пользователя нет,повторите ввод"
			 rm $tmp_FoundUser1
		      ;;
		      *)while read line
			do FoundUser=$line
			done < $tmp_FoundUser1
			echo "$FoundUser"
			rm $tmp_FoundUser1
			break
		      ;; # если количество байт не равно 0 то считываем имя пользователя в переменную
		esac
	done
	passwd $FoundUser #изменение пароля
	read -p  "Повторить?(y/n) " response
	case $response in
			[Nn]*)
				echo "---------------------------------------"
				rm $tmp_Users
				exit 0;;
			[Yy]*)
				continue;;
		"--help"|"-h")
				change_password
				continue;;
		"--back"|"-b")
				exit 0;;
				*)
				echo "Введите y/n"
	esac
done


