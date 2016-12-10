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
cut -d : -f1 /etc/passwd | cat -n | awk '$1=$1' > Users.txt #вывод пользователей из файла etc/passwd в фаил
cat Users.txt
GENLOOP=1
while((GENLOOP));do
	LOOP=1
	while((LOOP)); do
		echo "Введите имя пользователя или его порядковый номер"
		read user
	 	case $user in
	        "--help"|"-h"*)
			found_user_help
			continue;;
	        "--back"|"-b")
			echo "---------------------------------------"
			exit 0;;
	        *);;
	        esac
		grep -w $user Users.txt | cut -d' ' -f2 > FoundUser1.txt #поиск указанного пользователя и вывод его в фаил
		Len=$(stat -c%s FoundUser1.txt) #количество байтов в файле
		case $Len in
		      0)echo "Такого пользователя нет,повторите ввод"
			 rm FoundUser1.txt
		      ;;
		      *)while read line
			do FoundUser=$line
			done < FoundUser1.txt
			echo "$FoundUser"
			rm FoundUser1.txt
			break
		      ;; # если количество байт не равно 0 то считываем имя пользователя в переменную
		esac
	done
	sudo passwd $FoundUser #изменение пароля
	read -p  "Повторить?(y/n) " response
	case $response in
			[Nn]*)
				echo "---------------------------------------"
				rm Users.txt
				exit 0;;
			[Yy]*)
				TOTAL_LOOP=1
				break;;
		"--help"|"-h")
				change_password
				continue;;
		"--back"|"-b")
				exit 0;;
				*)
				echo "Введите y/n"
		esac
done


