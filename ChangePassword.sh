#!/bin/bash
#изменение пароля


if [[ $(whoami) != root ]]; then
	echo "Выполните вход в root"
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
		grep -w $user Users.txt | cut -d' ' -f2 > FoundUser1.txt #поиск указанного пользователя и вывод его в фаил
		Len=$(stat -c%s FoundUser.txt) #количество байтов в файле
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
	echo "Повторить?(y/n)"
	read answer
	if [[ $answer == "n" ]]
	then
	 break
	fi
done


