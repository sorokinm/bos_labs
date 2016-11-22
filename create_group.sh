#!/bin/bash
#create group

TOTAL_LOOP=1

while (( TOTAL_LOOP )); do

echo "Cуществующие группы:"
echo "--------------------"

cut -d: -f1 /etc/group | sort -d  #выводит группы, которые уже есть
echo "--------------------"

LOOP=1
while (( LOOP )); do

echo "Введите имя новой группы: (Введите q чтобы выйти)" #ввод названия группы
read GROUP


ISVALID=1
if [ $GROUP == '-' ] || [ $GROUP == '+' ];
	then
		ISVALID=0
fi

SYMB=${GROUP:0:1}
if [ $SYMB == '-' ] || [ $SYMB == '+' ];
		then
		ISVALID=0
fi
#-----
#for I in $(seq 0 $((${#GROUP}-1))); 
#do 
#SYMB=${GROUP:$I:1}
#if [ $SYMB == '-' ] || [ $SYMB == '+' ];
#then 
#	echo "true"
#else
#	echo "false"
#fi
#echo $SYMB;
#done 
 


case $GROUP in
	"q") echo "Выход из программы"
		 exit 0
	 	 break;;

	*) if [ $ISVALID == '1' ]; 
			then 
				sudo groupadd $GROUP 
			else
				echo "Недопустимое имя"
	   fi  #создает группу или выводит ошибку
	   break;; 
esac

done



MICRO_LOOP=1

while (( MICRO_LOOP )); do
read -p "Создать другую группу? (y/n) " RESPONSE #вдруг нужно еще групп

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


