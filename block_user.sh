#!/bin/bash
echo "---------------------------------------"
if [[ $(whoami) != root ]]; then
	echo "Выполните вход в root"
echo "---------------------------------------"
	exit 1
fi
while ((1));do	
	tmp_result="$(mktemp)"
	tmp_findResult="$(mktemp)"
	tmp_userPasswd="$(mktemp)"
	cut -d: -f1,3 /etc/passwd | awk '$1=$1' | tr -s ' ' ':' | awk -F : '(($2>=1000)&&($1!="nfsnobody")){print $1}' | cat -n | awk '$1=$1' > $tmp_result #вывести список пользователей, пронумеровав его и убрав повторяющиеся пробелы	
	cat $tmp_result
	echo "Введите имя пользователя или порядковый номер"
	read choose
	case $choose in
	-*)echo "Пользователь не найден" 
		continue;;	
	esac
	grep -w $choose $tmp_result | cut -d' ' -f2 > $tmp_findResult #выбор из списка пользователей имени введенного пользователя
	findResultLen=$(stat -c%s $tmp_findResult) #определение количества символов в файле с именем пользователя (если длина файла 0, то вывести "Пользователь не найден")
	case $findResultLen in
		0)echo "Пользователь не найден"
	 	 echo "Скрипт закончил работу"
          		rm $tmp_result 
			rm $tmp_findResult
			while ((1));do
        			echo "Повторить?(y/n)"
        			read repeat
        			case $repeat in
                			"y")repeats=1
                        			break;;
                			"n")echo "Выполняется выход..."
						echo "---------------------------------------"
                        			repeats=0
                        			break;;
                			*)echo "Неверный ввод";;
        			esac
			done
		if (("$repeats"=="0"));then
			break
		elif (("$repeats"=="1"));then
			continue
		fi
			;;
		*)echo "Найден пользователь: " 
			cat $tmp_findResult
			;;
	esac
	while read line #записать имя пользователя в переменную foundUser
		do foundUser=$line
		break
	done < $tmp_findResult
	cat /etc/shadow | grep $foundUser | cut -d: -f2 > $tmp_userPasswd #записать пароль пользователя из /etc/shadow в userPasswd
	if grep -q '\!\!' $tmp_userPasswd
		then echo "Пользователь заблокирован, разблокировка невозможна, так как при разблокировке появится пользователь без пароля. Измените пароль пользователю и запустите скрипт еще раз."
		rm $tmp_result 
		rm $tmp_findResult
		rm $tmp_userPasswd
		echo "---------------------------------------"
		exit 0
	elif grep -q '\!.' $tmp_userPasswd #при блокировке пользователя в начало его пароля добавляется восклицательный знак, соответственно необходимо проверить его наличие
		then echo "Пользователь заблокирован"
		echo "Разблокировать?(y/n)"
		read decision
		case $decision in
			"y") usermod -U $foundUser
	       			echo "Скрипт завершил работу"
	       			rm $tmp_result 
	       			rm $tmp_findResult
	       			rm $tmp_userPasswd
	       			while ((1));do
        				echo "Повторить?(y/n)"
        				read repeat
        				case $repeat in
                				"y")repeats=1
                        				break;;
                				"n")echo "Выполняется выход..."
							echo "---------------------------------------"
                        				repeats=0
                        				break;;
             		   			*)echo "Неверный ввод";;
        				esac
				done
			if (("$repeats"=="0"));then
				break
			elif (("$repeats"=="1"));then
				continue
			fi
			;;
			"n")echo "Скрипт завершил работу"
	      			rm $tmp_result 
              			rm $tmp_findResult
              			rm $tmp_userPasswd
	     	 		while ((1));do
        				echo "Повторить?(y/n)"
        				read repeat
        				case $repeat in
                				"y")repeats=1
                        				break;;
                				"n")echo "Выполняется выход..."
							echo "---------------------------------------"
                        				repeats=0
                        				break;;
                				*)echo "Неверный ввод";;
       					 esac
				done
			if (("$repeats"=="0"));then
				break
			elif (("$repeats"=="1"));then
				continue
			fi
			;;
			*)echo "Неверный ввод"
	      			rm $tmp_result 
              			rm $tmp_findResult
              			rm $tmp_userPasswd
				;;	
		esac
	else echo "Пользователь разблокирован"
		rm $tmp_result 
		rm $tmp_findResult
		rm $tmp_userPasswd
	fi
	while ((1));do
		echo "Повторить?(y/n)"
		read repeat
		case $repeat in
			"y")repeats=1
				break;;
			"n")echo "Выполняется выход..."
				echo "---------------------------------------"
				repeats=0
				break;;
			*)echo "Неверный ввод";;
		esac	
	done
	if (("$repeats"=="0"));then
	break	
	fi
done

