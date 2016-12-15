#!/bin/bash
#remove a user from of group
ME=$(whoami)

case $ME in
	"root")

LOOP=1

while [ $LOOP -eq 1 ]; do

#start input group name
GROUP_ISVALID=1
REPEAT_GROUP_INPUT=1
echo "Выберите группу из списка существующих:"		
echo "---------------------------------------"
cut -d: -f1 /etc/group | sort -d  
echo "---------------------------------------"




while [ $REPEAT_GROUP_INPUT -eq 1 ]; do
echo "Введите имя группы:  (-q - выход)"		
read GROUP


if [[ "$GROUP" == "-q" ]];		#exit if you wish
	then
		echo "Выход из программы..."
		exit 0
fi




#input validation	
GROUP_ISVALID=1					

if [[ -z $GROUP ]];
	then
		GROUP_ISVALID=0
fi

for I in $(seq 0 $((${#GROUP}-1))); 			
do 
SYMB=${GROUP:$I:1}

if [ $I -eq 0 ] 
	then
		if [ $SYMB == "-" ] || [ $SYMB == "+" ] || [ -z $SYMB  ];
			then 
				GROUP_ISVALID=0
				break
		fi
	else
		if [ -z $SYMB  ];
			then 
				GROUP_ISVALID=0
				break
		fi

fi
done 
#input validation	 


FOUND_IN_LIST=""

if [ $GROUP_ISVALID -eq 1 ];
	then	
		FOUND_IN_LIST=$(cut -d: -f1 /etc/group | grep -w "$GROUP")
fi




if [ $GROUP_ISVALID -eq 0 ] || [[ -z $FOUND_IN_LIST ]];
	then
		echo "Введено недопустимое или несуществующее имя группы. Повторите ввод"
	else
		REPEAT_GROUP_INPUT=0
fi

done
#end input group name



if [[ "$GROUP" == "-q" ]];	#если ввели q то выходим
	then
		exit 0
	else 
		USER_LIST=$(cut -d: -f1,4 /etc/group | grep -w "$GROUP" | cut -d: -f2)
		USER=""

		if [ -z $USER_LIST ];
			then 
				echo "В группе нет пользователей"
			else
				echo "Список пользователей:"
				echo $USER_LIST  | tr ',' '\n' > /tmp/temp
				cat -n /tmp/temp 
				rm /tmp/temp


				
				REPEAT_USER_NAME_INPUT=1

				while [ $REPEAT_USER_NAME_INPUT -eq 1 ]; do
				echo "Введите имя или порядковый номер пользователя, которого хотите удалить: (введите -q для выхода)"
				read NAME 
				
				if [[ "$NAME" == "-q" ]];
					then
						echo "Выход из программы"
						exit  0
				fi

				USER_NAME_IS_VALID=1		#валидируем ввод на пустую строку и ключи
				if [[ -z $NAME ]];
					then
						USER_NAME_IS_VALID=0
				fi

				for I in $(seq 0 $((${#NAME}-1))); 			
				do 
					SYMB=${NAME:$I:1}

					if [ $I -eq 0 ] 
						then
							if [ $SYMB == "-" ] || [ $SYMB == "+" ] || [ -z $SYMB  ];
								then 
									USER_NAME_IS_VALID=0
									break
							fi
						else
							if [ -z $SYMB  ];
								then 
									USER_NAME_IS_VALID=0
									break
							fi

					fi
				done 



				if [ $USER_NAME_IS_VALID -eq 1 ]; then		
				IS_NUMBER=1
				for I in $(seq 0 $((${#NAME}-1))); do 			#определяет, ввели ли мы индекс или имя
					SYMB=${NAME:$I:1}
					case $SYMB in 
						[1234567890]) IS_NUMBER=$(( $IS_NUMBER * 1 ))
									  ;;
						*) IS_NUMBER=$(( $IS_NUMBER * 0 ))
							;;	
					esac
				done

				echo $USER_LIST  | tr ',' '\n' > /tmp/temp	
				USER_COUNT=$(cat /tmp/temp | wc -l)
				rm /tmp/temp

				if [ $IS_NUMBER -eq 1 ]; 
				then 
				  if [ $NAME -le $USER_COUNT ] && [ $NAME != "0" ];
					then 												#если мы ввели индекс
						echo $USER_LIST  | tr ',' '\n' > /tmp/temp
						USER=$(head -n $NAME /tmp/temp | tail -n 1)						
						rm /tmp/temp
						REPEAT_USER_NAME_INPUT=0
				  fi
				
				else
												#если мы ввели имя, то попытаемся его найти
						USER_FOUND_IN_LIST=""
						echo $USER_LIST  | tr ',' '\n' > /tmp/temp
						USER_FOUND_IN_LIST=$(cat /tmp/temp | grep -w "$NAME")
						USER_COUNT=$(cat /tmp/temp | wc -l)
						rm /tmp/temp

						if [[ -z $USER_FOUND_IN_LIST ]];
					 		then 
					 			echo "Введено несуществующее имя или индекс. Повторите ввод"
								REPEAT_USER_NAME_INPUT=1
							else
								USER=$NAME
								REPEAT_USER_NAME_INPUT=0
				
						fi

				  
				fi

				else				
					echo "Введено несуществующее имя или индекс. Повторите ввод"
					REPEAT_USER_NAME_INPUT=1
				fi
				done

				
 

				gpasswd -d "$USER" "$GROUP"
				#sudo deluser "$USER" "$GROUP"
				echo "Пользователь $USER успешно удален из группы $GROUP"

		fi
fi


MICRO_LOOP=1
while (( MICRO_LOOP )); do
read -p "Повторить? (y/n) " RESPONSE #вдруг нужно еще 

case $RESPONSE in
[Yy]* ) MICRO_LOOP=0
		LOOP=1
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