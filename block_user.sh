#!/bin/bash
who=$(whoami)
case $who in
	"root")
cut -d: -f1 /etc/passwd | cat -n | awk '$1=$1' > result.txt #вывести список пользователей, пронумеровав его и убрав повторяющиеся пробелы
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
		exit 0
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
	       exit 0
	;;
	"n")echo "Скрипт завершил работу"
	      rm result.txt
              rm findResult.txt
              rm userPasswd.txt
	      exit 0
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
;;
*)echo "Выполните вход в root";;
esac
