#!/bin/bash
#create group

ME=$(whoami)

case $ME in
	"root")

TOTAL_LOOP=1

while (( TOTAL_LOOP )); do

#выводит группы, которые уже есть
echo "Cуществующие группы:"		
echo "--------------------"
cut -d: -f1 /etc/group | sort -d  
echo "--------------------"
#выводит группы, которые уже есть



LOOP=1
while (( LOOP )); do

echo "Введите имя новой группы: (Введите q чтобы выйти)" #ввод названия группы
read GROUP





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
#input validation end	 


if [ $ISVALID -eq 1 ];				#check if the group already exists
	then
		FOUND_IN_LIST=$(cut -d: -f1 /etc/group | sort -d | grep +x "$GROUP")
		if [[ -n $FOUND_IN_LIST ]];
			then ISVALID=0
		fi
fi



case $GROUP in
	"q") echo "Выход из программы"
		 exit 0
	 	 break;;

	*) if [ $ISVALID -eq 1 ]; 
			then 
				sudo groupadd $GROUP 
			else
				echo "Введено недопустимое имя или группа с указанным именем уже существует"
	   fi  #создает группу или выводит ошибку
	   break;; 
esac

done



MICRO_LOOP=1

while (( MICRO_LOOP )); do
read -p "Создать другую группу? (y/n) " RESPONSE #вдруг нужно еще групп

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