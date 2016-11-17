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
		rm findResult.txt
		rm result.txt
		exit 0
		;;
	*)echo "Найден пользователь: " 
		cat findResult.txt
		;;
esac
while read line  #записать имя пользователя в переменную foundUser
do	foundUser=$line
break
done < findResult.txt
echo "Удалить пользователя?(y/n)"
read delChoose
case $delChoose in
	"y")echo "Удалить домашний каталог пользователя?(y/n)"
		read catChoose
		;;
	"n")echo "Скрипт закончил работу"
		rm result.txt
		rm findResult.txt
		exit 0
		;;
	*)echo "Неверный ввод"
		echo "Скрипт закончил работу"
		rm result.txt
		rm findResult.txt
		exit 0
		;;	
esac	
case $catChoose in
	"y")userdel -r $foundUser
		echo "Скрипт закончил работу"
		rm result.txt
		rm findResult.txt
		exit 0
		;;
	"n")userdel $foundUser
		echo "Скрипт закончил работу"
		rm result.txt
		rm findResult.txt
		exit 0
		;;
	*)echo "Неверный ввод"
		echo "Скрипт закончил работу"
		rm result.txt
		rm findResult.txt
		exit 0
		;;
esac
;;
*)echo "Выполните вход в root";;
esac
