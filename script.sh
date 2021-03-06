#!/bin/bash

#показываем справочную информацию
show_help(){

echo "Использование: ./script.sh [КЛЮЧ]
Позволяет управлять пользователями(добавление, удаление, блокировка, добавление в группу, смена пароля)
и группами(добавление,удаление, изменение состава), а также осуществлять поиск пользователей или групп.
Выполнение любого из перечисленных выше действий происходит путем выбора соответствующего пункта в меню и ввода дополнительных аргументов.
SELinux options:
--help         показать эту справку и выйти

Коды возврата:
0 - все отлично" 
}


################# входная точка сценария
echo "Разработчики: Сорокин Михаил, Бабкин Сергей, Иванова Екатерина, Курнев Алексей, Степанова Анна"
if [ "$1" == "--help" ] ; then 
	show_help
else 
	echo "С помощью данной программы Вы сможете управлять пользователями и группами"
	
	if [[ $(whoami) != root ]]; then
		echo "Выполните вход в root"
		exit 1
	fi

	./main_menu.sh
fi;




