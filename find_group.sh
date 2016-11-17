#!/bin/bash
who=$(whoami)
case $who in 
	"root")# делай всё если пользователь root
;;
	"mic")
echo "Введите имя группы или часть имени"
# проверка на пустой ввод
while read input_name 
do
	input_len=${#input_name}
	if [ $input_len -eq 0 ] ; then
		echo "Вы ввели пустую строку!\nВведите имя группы или часть имени"
	else break;
	fi
done

case $input_name in
	"--help")
		;;
	"--back");;
	*);;
esac

#поиск групп с именем, начинающимся на input_name
groupnames="$(grep -i ^$input_name  /etc/group | cut -d: -f1)"
len=${#groupnames}
# если что-то найдено
if [ $len -ne 0  ] ; then
	for group in $groupnames
	do
		echo "Имя группы=$group"
		
	done
else
echo "Групп не найдено."
fi
;;
	*) 
echo "Выполните вход в root"
;;
esac
