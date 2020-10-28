#!/bin/bash

while [ $(cat block) -lt 3 ]; do read -p "Имя: " log; read -s -p "Пароль: " pass;
	while read ln; do data=(${ln//:/ });
		[ "$log" = "${data[0]}" ] && [ "$pass" = "${data[1]}" ] && grp=${data[2]} && break;
	done <<< "$(cat pwd)"
	[ -z "$grp" ] && echo "$(($(cat block) + 1))" > block && exit 1;
	while true; do read -p $'\n'"[$log]\$ " command;
		case $command in
			help) cat help; [ "$grp" == "admin" ] && cat admin;;
			users) cat pwd | while read ln; do echo $ln | cut -d":" -f1; done;;
			password) read -s -p "Текущий пароль: " old;
				[ "$pass" = "$old" ] && read -s -p $'\n'"Новый пароль: " new &&
					sed -ri '/^'$log'/s/'$old'/'$new'/' pwd || echo $'\n'"Ошибка пароля";;
			time) echo $(date);;
			logout) unset grp; break;;
			exit) exit 0;;
			add) [ "$grp" = "admin" ] &&
				read -p "Имя: " nl && read -s -p "Пароль: " np && read -p $'\n'"Права: " ng &&
				echo "$nl:$np:$ng" >> "pwd";;
			remove) [ "$grp" == "admin" ] && read -p "Имя: " rem && sed -ni '/'$rem':/!p' pwd;
		esac
	done
done
