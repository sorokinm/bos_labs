#!/bin/bash
who=$(whoami)
case $who in
	"root")
while ((1));do	
cut -d: -f1,3 /etc/passwd | awk '$1=$1' | tr -s ' ' ':' | awk -F : '(($2>=1000)&&($1!="nfsnobody")){print $1}' | cat -n | awk '$1=$1' > result.txt #вывести список пользователей, пронумеровав его и убрав повторяющиеся пробелы
cat result.txt
echo "Введите имя пользователя или порядковый номер"
read choose
grep -w $choose result.txt | cut -d' ' -f2 > findResult.txt #выбор из списка пользователей имени введенного пользователя
findResultLen=$(stat -c%s findResult.txt) #определение количества символов в файле с именем пользователя (если длина файла 0, то вывести "Пользователь не найден")
case $findResultLen in
	0)echo "Пользователь не найден"
	  echo "Скрипт закончил работу"
          	rm result.txt 
		rm findResult.txt
		while ((1));do
        echo "Повторить?(y/n)"
        read repeat
        case $repeat in
                "y")$repeats=1
                        break;;
                "n")echo "Выполняется выход..."
                        $repeats=0
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
		cat findResult.txt
		;;
esac
while read line #записать имя пользователя в переменную foundUser
do	foundUser=$line
break
done < findResult.txt
cat /etc/shadow | grep $foundUser | cut -d: -f2 > userPasswd.txt #записать пароль пользователя из /etc/shadow в userPasswd.txt
if grep -q '\!' userPasswd.txt
then echo "Пользователь заблокирован, разблокировка невозможна, так как при разблокировке появится пользователь без пароля. Измените пароль пользователю и запустите скрипт еще раз."
rm result.txt
rm findResult.txt
rm userPasswd.txt
exit 0
elif grep -q '\!.' userPasswd.txt #при блокировке пользователя в начало его пароля добавляется восклицательный знак, соответственно необходимо проверить его наличие
then echo "Пользователь заблокирован"
echo "Разблокировать?(y/n)"
read decision
case $decision in
	"y") usermod -U $foundUser
	       echo "Скрипт завершил работу"
	       rm result.txt
	       rm findResult.txt
	       rm userPasswd.txt
	       while ((1));do
        echo "Повторить?(y/n)"
        read repeat
        case $repeat in
                "y")$repeats=1
                        break;;
                "n")echo "Выполняется выход..."
                        $repeats=0
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
	      rm result.txt
              rm findResult.txt
              rm userPasswd.txt
	      while ((1));do
        echo "Повторить?(y/n)"
        read repeat
        case $repeat in
                "y")$repeats=1
                        break;;
                "n")echo "Выполняется выход..."
                        $repeats=0
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
	      rm result.txt
              rm findResult.txt
              rm userPasswd.txt
	;;
esac
else echo "Пользователь разблокирован"
rm result.txt
rm findResult.txt
rm userPasswd.txt
fi
while ((1));do
	echo "Повторить?(y/n)"
	read repeat
	case $repeat in
		"y")repeats=1
			break;;
		"n")echo "Выполняется выход..."
			repeats=0
			break;;
		*)echo "Неверный ввод";;
	esac	
done
if (("$repeats"=="0"));then
break	
fi
done
;;
*)echo "Выполните вход в root";;
esac
