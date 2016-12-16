#!/bin/bash
#add user to group
function add_user_to_group () {
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
tmp_AllUsers="$(mktemp)"
tmp_FoundUser="$(mktemp)"
tmp_AllGroups="$(mktemp)"
tmp_FoundGroup="$(mktemp)"
cut -d : -f1 /etc/passwd | cat -n | awk '$1=$1' > $tmp_AllUsers #вывод пользователей из файла etc/passwd в фаил
cat $tmp_AllUsers
GENLOOP=1
while((GENLOOP));do
	LOOP=1
	while((LOOP)); do
		echo "Введите имя пользователя или его порядковый номер (для выхода -q)"
		read user
		if [ ${#user} -eq 0 ]; then
			continue
		fi

		case $user in
		"--help"|"-h")
			add_user_to_group
			continue
			;;
		"--quit"|"-q")
			echo "---------------------------------------"
			exit 0;;
		*);;
	        esac
		s=${user:0:1}
		if [ $s == "-" ]; then
			continue
		fi
		grep -w $user $tmp_AllUsers | cut -d' ' -f2 > $tmp_FoundUser #поиск указанного пользователя и вывод его в фаил
		Len=$(stat -c%s $tmp_FoundUser) #количество байтов в файле
		case $Len in      
		      0)echo "Такого пользователя нет,повторите ввод"
			 rm $tmp_FoundUser
		      ;;
		      *)while read line
			do FoundUser=$line
			done < $tmp_FoundUser
			echo "$FoundUser"
			rm $tmp_FoundUser
			break
		      ;; # если количество байт не равно 0 то считываем имя пользователя в переменную
		esac
	done
	cut -d : -f1 /etc/group | cat -n | awk '$1=$1' > $tmp_AllGroups #вывод пользователей в фаил
	cat $tmp_AllGroups
	LOOP1=1
	while((LOOP1)); do
		echo "Введите имя или порядковый номер группы (для выхода -q)"
		read group
		case $group in
			"--help"|"-h")
						add_user_to_group
						continue;;
			"--quit"|"-q")
						exit 0;;
		esac
		
		if [ ${#group} -eq 0 ]; then
			continue
		fi
		v=${group:0:1}
		if [ $v == "-" ]; then
			continue
		fi
		grep -w $group $tmp_AllGroups | cut -d' ' -f2 > $tmp_FoundGroup #поиск заданной группы
		Len1=$(stat -c%s $tmp_FoundGroup ) #количество байт в файле
		case $Len1 in
		      0)echo "Такой группы  нет"
			 rm $tmp_FoundGroup 
		      ;;
		      *) 
			while read line
			do FoundGroup=$line
			done < $tmp_FoundGroup 
			echo "$FoundGroup"
			rm $tmp_FoundGroup 
			break 
		      ;; #если число байт не 0 ,то записываем введенное значение в переменную
		esac
	done
	#sudo usermod -aG  $FoundGroup $FoundUser #добавление пользователя в группу
	gpasswd -a $FoundUser $FoundGroup
	read -p  "Повторить?(y/n) " response
        case $response in
			[Nn]*)
				echo "---------------------------------------"
				rm $tmp_AllUsers
				exit 0;;
			[Yy]*)
				continue;;
	"--help"|"-h")
				add_user_to_group
				continue;;
	"--quit"|"-q")
				exit 0;;
				*)
				echo "Введите y/n"
	esac
done

