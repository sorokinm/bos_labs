#!/bin/bash
#Поиск пользователей и групп


#попадаем в подменю

#пункты подменю
options=(
	"Найти пользователя"
	"Найти группу"  
)
PS3="Введите опцию(q- возврат назад, help -справка) "
all_done=0
#переход в пункт меню в зависимости от выбора
while (( !all_done )); do  #цикл обеспечивает повторный вывод меню
	echo "-----------------
Меню поиска пользователей и групп"
	select opt in "${options[@]}"
	do
		case "$REPLY" in
			1)
				# "Найти пользователя"
				./find_user.sh
				break
				;;
			2)
				# "Найти группу"
				./find_group.sh 
				break
				;;
			
			"q")
				# "Возврат назад"
				all_done=1
				break
				;;
			"help")
				echo "----------------
Справка:
1)Найти пользователя -поиск пользователей и вывод основной информации о них
2)Найти группу - поиск групп и вывод основной информации о них"
				break
				;;
			*) echo "Вы неправильно выбрали опцию. Пожалуйста, попробуйте еще раз" >&2
				break
				;;
		esac
	done
done
			
		

