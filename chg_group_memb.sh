#!/bin/bash

#Изменение состава группы


#попадаем в подменю

#пункты подменю
options=(
	"Добавить пользователя в группу"
	"Удалить пользователя из группы" 
)
PS3="Введите опцию(q- возврат назад, help - справка) "
all_done=0
#переход в пункт меню в зависимости от выбора
while (( !all_done )); do  #цикл обеспечивает повторный вывод меню
	echo "-----------------
Меню изменения состава группы"
	select opt in "${options[@]}"
	do
		case "$REPLY" in
			1)  ./AddUserToGroup.sh
				#"Добавить пользователя вгруппу"
				break
				;;
			2)	./remove_user_from_group.sh
				# "Удалить пользователя из группы" 
				break
				;;
			
			"q")
				echo "Возврат назад"
				all_done=1
				break
				;;
			"help")
				echo "------------
Справка:
1)Добавить пользователя в группу - добавление пользователя в группу
2)Удалить пользователя из группы - удаление пользователя из группы"
				break
				;;
			*) echo "Вы неправильно выбрали опцию. Пожалуйста, попробуйте еще раз" >&2
				break
				;;
		esac
	done
done
			
		
