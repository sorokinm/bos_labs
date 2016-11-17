#!/bin/bash
#Управление группами


#попадаем в подменю

#пункты подменю
options=(
	"Добавить группу"
	"Удалить группу" 
	"Изменить состав группы" 
)
PS3="Введите опцию(q- возврат назад, help - справка) "
all_done=0
#переход в пункт меню в зависимости от выбора
while (( !all_done )); do  #цикл обеспечивает повторный вывод меню
	echo "-----------------
Меню управления группами"
	select opt in "${options[@]}"
	do
		case "$REPLY" in
			1)
				echo "Добавить группу"
				break
				;;
			2)
				echo "Удалить группу" 
				break
				;;
			3)
				#"Изменить состав группы"
				./chg_group_memb.sh
				break				
				;;
			"help")
				echo "-----------
Справка:
1)Добавить группу - добавление новой группы
2)Удалить группу - удаление существующей группы
3)Изменить состав группы - добавление или удаление пользователя из группы"
				break
				;;
			"q")
				echo "Возврат назад"
				all_done=1
				break
				;;
			*) echo "Вы неправильно выбрали опцию. Пожалуйста, попробуйте еще раз" >&2
				break
				;;
		esac
	done
done
			
		