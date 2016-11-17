#!/bin/bash
who=$(whoami)
case $who in 
	"root")# делай всё если пользователь root
;;
	"mic")
echo "Введите имя пользователя или часть имени"
# проверка на пустой ввод
while read input_name 
do
	input_len=${#input_name}
	if [ $input_len -eq 0 ] ; then
		echo "Вы ввели пустую строку!\nВведите имя пользователя или часть имени"
	else break;
	fi
done

case $input_name in
	"--help")
		;;
	"--back");;
	*);;
esac

#поиск пользователей с именем, начинающимся на input_name
usernames="$(grep -i ^$input_name  /etc/passwd | cut -d: -f1)"
len=${#usernames}
# если что-то найдено
if [ $len -ne 0  ] ; then
	for user in $usernames
	do
		echo "Имя пользователя=$user"
		id $user # далее будем использовать lslogins (работает только на Авроре)
	done
else
echo "Пользователей не найдено."
fi
;;
	*) 
echo "Выполните вход в root"
;;
esac
