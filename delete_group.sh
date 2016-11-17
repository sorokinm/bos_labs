#!/bin/bash
#delete group

TOTAL_LOOP=1

while (( TOTAL_LOOP )); do

echo "Cуществующие группы:
---------------------"

cut -d: -f1 /etc/group | sort -d  #выводит группы, которые уже есть
echo "--------------------"

LOOP=1
while (( LOOP )); do

echo "Введите имя группы, которую хотите удалить: (Введите q чтобы выйти)" #ввод названия группы
read GROUP

case $GROUP in
	"q") echo "Выход из программы"
		 exit 0
	 	 break;;

	*) sudo groupdel $GROUP  #удаляет группу или выводит ошибку
	   break;; 
esac

done



MICRO_LOOP=1

while (( MICRO_LOOP )); do
read -p "Удалить другую группу? (y/n) " RESPONSE #вдруг нужно еще меньше групп

case $RESPONSE in
[Yy]* ) $MICRO_LOOP=0
		$TOTAL_LOOP=1
		break;;
[Nn]* ) echo "Выход из программы"
		exit 0
		break;;
*) echo "Ответьте y/n"
esac

done



done
