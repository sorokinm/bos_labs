#!/bin/bash
function found_user_help () {
echo "Для выхода в меню нажмите --back или -b
Для вызова справки --help или -h
"
}

echo "---------------------------------------"
who=$(whoami)
case $who in 
	"root")# делай всё если пользователь root
TOTAL_LOOP=1
while [[ $TOTAL_LOOP -eq 1 ]]; do

echo "Введите имя группы или часть имени"
# проверка на пустой ввод
while read input_name 
do
	input_len=${#input_name}
	if [ $input_len -eq 0 ] ; then
		echo "Вы ввели пустую строку!
Введите имя группы или часть имени"
	else break;
	fi
done

case $input_name in
	"--help"|"-h"*)
		found_user_help
		continue
		;;
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
		echo "Имя группы $name
 GID= $GID"
		participants="$(lid -g $name)"
		if [ ${#participants} -ne 0 ] ; then
			echo " Пользователи группы:"
			for member in $participants
			do
				echo " $member"
			done
		else echo "Пользователей не найдено."
		fi
	done <<< "$groupnames"
else
echo "Групп не найдено."
fi

MICRO_LOOP=1

while [[ $MICRO_LOOP -eq 1 ]]; do
read -p  "Найти группу ещё?(y/n) " response

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
		continue
		;;
	"--back"|"-b")
		exit 0;;
	*)
		echo "Введите y/n"
esac

done


done
;;
	*) 
echo "Выполните вход в root"
;;
esac
echo "---------------------------------------"
