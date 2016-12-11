#!/bin/bash
#add user to group
function add_user_to_group () {
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
cut -d : -f1 /etc/passwd | cat -n | awk '$1=$1' > AllUsers.txt #вывод пользователей из файла etc/passwd в фаил
cat AllUsers.txt
GENLOOP=1
while((GENLOOP));do
	LOOP=1
	while((LOOP)); do
		echo "Введите имя пользователя или его порядковый номер"
		read user
		case $user in
		"--help"|"-h")
			add_user_to_group
			continue
			;;
		"--back"|"-b")
			echo "---------------------------------------"
			exit 0;;
		*);;
	        esac
		grep -w $user AllUsers.txt | cut -d' ' -f2 > FoundUser.txt #поиск указанного пользователя и вывод его в фаил
		Len=$(stat -c%s FoundUser.txt) #количество байтов в файле
		case $Len in      
		      0)echo "Такого пользователя нет,повторите ввод"
			 rm FoundUser.txt
		      ;;
		      *)while read line
			do FoundUser=$line
			done < FoundUser.txt
			echo "$FoundUser"
			rm FoundUser.txt
			break
		      ;; # если количество байт не равно 0 то считываем имя пользователя в переменную
		esac
	done
	cut -d : -f1 /etc/group | cat -n | awk '$1=$1' > AllGroups.txt #вывод пользователей в фаил
	cat AllGroups.txt
	LOOP1=1
	while((LOOP1)); do
		echo "Введите имя или порядковый номер группы"
		read group
		grep -w $group AllGroups.txt | cut -d' ' -f2 > FoundGroup.txt #поиск заданной группы
		Len1=$(stat -c%s FoundGroup.txt) #количество байт в файле
		case $Len1 in
		      0)echo "Такой группы  нет"
			 rm FoundGroup.txt
		      ;;
		      *) 
			while read line
			do FoundGroup=$line
			done < FoundGroup.txt
			echo "$FoundGroup"
			rm FoundGroup.txt
			break 
		      ;; #если число байт не 0 ,то записываем введенное значение в переменную
		esac
	done
	sudo usermod -aG  $FoundGroup $FoundUser #добавление пользователя в группу
	read -p  "Повторить?(y/n) " response
        case $response in
			[Nn]*)
				echo "---------------------------------------"
				rm AllUsers.txt
				exit 0;;
			[Yy]*)
				continue;;
	"--help"|"-h")
				add_user_to_group
				continue;;
	"--back"|"-b")
				exit 0;;
				*)
				echo "Введите y/n"
	esac
done

