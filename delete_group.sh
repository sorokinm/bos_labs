#!/bin/bash
#delete group

ME=$(whoami)

case $ME in
	"root")

TOTAL_LOOP=1

while (( TOTAL_LOOP )); do

echo "Cуществующие группы:
---------------------"

cut -d: -f1 /etc/group | sort -d  #выводит группы, которые уже есть
echo "--------------------"

LOOP=1
while (( LOOP )); do

echo "Введите имя группы, которую хотите удалить: (Введите -q чтобы выйти)" #ввод названия группы
read GROUP

if [[ "$GROUP" == "-q" ]];
	then
		echo "Выход из программы..."
		exit 0
fi


#input validation	
ISVALID=1					

if [[ -z $GROUP ]];
	then
		ISVALID=0
fi

for I in $(seq 0 $((${#GROUP}-1))); 			
do 
SYMB=${GROUP:$I:1}

if [ $I -eq 0 ] 
	then
		if [ $SYMB == "-" ] || [ $SYMB == "+" ] || [ -z $SYMB  ];
			then 
				ISVALID=0
				break
		fi
	else
		if [ -z $SYMB  ];
			then 
				ISVALID=0
				break
		fi

fi
done 
#input validation	 

if [ $ISVALID -eq 1 ];
	then
		FOUND_IN_LIST=$(cut -d: -f1 /etc/group | sort -d | grep -w "$GROUP")
		if [[ -z $FOUND_IN_LIST ]];
			then ISVALID=0
		fi
fi


case $GROUP in
#	"q") echo "Выход из программы"
#		 exit 0
#	 	 break;;

	*) if [ $ISVALID -eq 1 ]; 
	   		then
				sudo groupdel $GROUP  #удаляет группу или выводит ошибку
	   		else
				echo "Введено недопустимое или несуществующее имя"
	   fi
	   break;; 
esac

done



MICRO_LOOP=1

while (( MICRO_LOOP )); do
read -p "Удалить другую группу? (y/n) " RESPONSE #вдруг нужно еще меньше групп

case $RESPONSE in
[Yy]* ) MICRO_LOOP=0
		TOTAL_LOOP=1
		break;;
[Nn]* ) echo "Выход из программы"
		exit 0
		break;;
*) echo "Ответьте y/n"
esac

done



done
break;;

*) echo "Вы не являетесь root-пользователем"

esac