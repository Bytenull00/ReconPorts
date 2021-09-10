#!/bin/bash

# Author: Gustavo Segundo - ByteNull%00

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

export DEBIAN_FRONTEND=noninteractive

	cat <<-'EOF'
  _____                      _____           _       
 |  __ \                    |  __ \         | |      
 | |__) |___  ___ ___  _ __ | |__) |__  _ __| |_ ___ 
 |  _  // _ \/ __/ _ \| '_ \|  ___/ _ \| '__| __/ __|
 | | \ \  __/ (_| (_) | | | | |  | (_) | |  | |_\__ \
 |_|  \_\___|\___\___/|_| |_|_|   \___/|_|   \__|___/
                                                     v1.1 codead by ByteNull%00
                                                     email: gasso2do@gmail.com

	EOF

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Exit ...${endColour}"
	tput cnorm; 
	exit 1
}

function helpPanel(){
	echo -e "Help Panel"
	echo -e "\t i) Segment"	
	echo -e "\t\t ./ReconPorts.sh -i 192.168.1.0-254"
	echo -e "\t f) File with IP addresses"
	echo  -e "\t\t ./ReconPorts.sh -f ips.txt"
	exit 0
}

function StartIPs(){
	TARGET=$reconIPs
	ip_first="$(echo $TARGET | cut -d '.' -f 4 | cut -d '-' -f 1)"
	ip_last="$(echo $TARGET | cut -d '.' -f 4 | cut -d '-' -f 2)"
	bloque="$(echo $TARGET | cut -d '.' -f 1,2,3)"
	
	results=output
	
	if [ -d "$results" ]; then
   		:
	else
		mkdir output
	fi

	echo "" > $results/ftp.txt; echo "" > $results/ssh.txt; echo "" > $results/mysql.txt ;echo "" > $results/http.txt
	echo "" > $results/vnc.txt; echo "" > $results/tomcat.txt 
	echo "" > $results/mssql.txt; echo "" > $results/postgresql.txt; echo "" > $results/oracle.txt; echo "" > $results/telnet.txt
	echo "" > $results/ajp.txt
	STARTTIME=$(date +%s)
	sleep 0.5
	echo -e "\n${yellowColour}[*] Starting ... ${endColour}"
	sleep 0.5
	echo -e "\n${blueColour}[*] Scan Ports FTP,SSH,TELNET,HTTP,HTTPS,ORACLE,MSSQL,MYSQL,POSTGRESQL,AJP,TOMCAT,VNC ${endColour}"
	declare -i count_vulnerable=0
	STARTTIME2=$(date +%s)
	for (( c="$(echo $ip_first)"; c<="$(echo $ip_last)"; c++ )); do

		nmap -n -Pn -p21,22,23,80,443,1433,1521,3306,5432,5800,5900,8009,8080,8081,8443,8090 --open $bloque.$c 2>/dev/null | grep open | awk '{print $1}' FS='/' > ports.txt
		count_http=0
		count_vnc=0
		count_tomcat=0
		echo "" >> $results/http.txt; echo "" >> $results/vnc.txt; echo "" >> $results/tomcat.txt
		while read port; do
	   		if [ "21" == $port ]; then
	   			echo $bloque.$c >> $results/ftp.txt
	   		elif [ "22" == $port ]; then
	   			echo $bloque.$c >> $results/ssh.txt
	   		elif [ "23" == $port ]; then
	   			echo $bloque.$c >> $results/telnet.txt
	   		elif [ "80" = $port ] || [ "443" = $port ]; then
	   			if [ "0" == $count_http ]; then
	   				echo -e "$bloque.$c $port,\c" >> $results/http.txt
	   				count_http=1
	   			else
	   				echo $port >> $results/http.txt
	   			fi
	   		elif [ "1433" == $port ]; then
	   			echo $bloque.$c >> $results/mssql.txt
	   		elif [ "1521" == $port ]; then
	   			echo $bloque.$c >> $results/oracle.txt
	   		elif [ "3306" == $port ]; then
	   			echo $bloque.$c >> $results/mysql.txt
	   		elif [ "5432" == $port ]; then
	   			echo $bloque.$c >> $results/postgresql.txt
	   		elif [ "5800" = $port ] || [ "5900" = $port ]; then
	   			if [ "0" == $count_vnc ]; then
	   				echo -e "$bloque.$c $port,\c" >> $results/vnc.txt
	   				count_vnc=1
	   			else
	   				echo $port >> $results/vnc.txt
	   			fi
	   		elif [ "8009" == $port ]; then
	   			echo $bloque.$c >> $results/ajp.txt
	   		elif [ "8080" = $port ] || [ "8081" = $port ] || [ "8443" = $port ] || [ "8090" = $port ]; then
	   			if [ "0" == $count_tomcat ]; then
	   				echo -e "$bloque.$c $port,\c" > $results/tomcat.txt 
	   				count_tomcat=1
	   			else
	   				echo $port >> $results/tomcat.txt
	   			fi
	   		fi

		done < ports.txt
	done
	sed -i '/^$/d' $results/http.txt; sed -i '/^$/d' $results/tomcat.txt; sed -i '/^$/d' $results/vnc.txt
	sed -i '/^$/d' $results/oracle.txt; sed -i '/^$/d' $results/mysql.txt; sed -i '/^$/d' $results/ssh.txt
	sed -i '/^$/d' $results/ftp.txt; sed -i '/^$/d' $results/telnet.txt; sed -i '/^$/d' $results/postgresql.txt
	sed -i '/^$/d' $results/mssql.txt	
	echo ""
	echo -e "${greenColour}[*] Saving results in ftp.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in ssh.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in http.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in mssql.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in oracle.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in mysql.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in postgresql.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in vnc.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in ajp.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in tomcat.txt ${endColour}"
	sleep 0.5
	echo -e "\n${grayColour}[*] Files saving in directory $results ${endColour}"
	sleep 0.5
	ENDTIME=$(date +%s)
	echo -e "\n${yellowColour}It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task, Good Bye :) ${endColour}"
}

function StartFile(){
		TARGET=$reconFile
		results=output
	
	if [ -d "$results" ]; then
   		:
	else
		mkdir output
	fi

	echo "" > $results/ftp.txt; echo "" > $results/ssh.txt; echo "" > $results/mysql.txt ;echo "" > $results/http.txt
	echo "" > $results/vnc.txt; echo "" > $results/tomcat.txt 
	echo "" > $results/mssql.txt; echo "" > $results/postgresql.txt; echo "" > $results/oracle.txt; echo "" > $results/telnet.txt
	echo "" > $results/ajp.txt
	STARTTIME=$(date +%s)
	sleep 0.5
	echo -e "\n${yellowColour}[*] Starting ... ${endColour}"
	sleep 0.5
	echo -e "\n${blueColour}[*] Scan Ports FTP,SSH,TELNET,HTTP,HTTPS,ORACLE,MSSQL,MYSQL,POSTGRESQL,AJP,TOMCAT,VNC ${endColour}"
	declare -i count_vulnerable=0
	STARTTIME2=$(date +%s)
	while read ip; do

		nmap -n -Pn -p21,22,23,80,443,1433,1521,3306,5432,5800,5900,8009,8080,8081,8443,8090 --open $ip 2>/dev/null | grep open | awk '{print $1}' FS='/' > ports.txt 
		count_http=0
		count_vnc=0
		count_tomcat=0
		echo "" >> $results/http.txt; echo "" >> $results/vnc.txt; echo "" >> $results/tomcat.txt
		while read port; do
	   		if [ "21" == $port ]; then
	   			echo $ip >> $results/ftp.txt
	   		elif [ "22" == $port ]; then
	   			echo $ip >> $results/ssh.txt
	   		elif [ "23" == $port ]; then
	   			echo $ip >> $results/telnet.txt
	   		elif [ "80" = $port ] || [ "443" = $port ]; then
	   			if [ "0" == $count_http ]; then
	   				echo -e "$ip $port,\c" >> $results/http.txt
	   				count_http=1
	   			else
	   				echo $port >> $results/http.txt
	   			fi
	   		elif [ "1433" == $port ]; then
	   			echo $ip >> $results/mssql.txt
	   		elif [ "1521" == $port ]; then
	   			echo $ip >> $results/oracle.txt
	   		elif [ "3306" == $port ]; then
	   			echo $ip >> $results/mysql.txt
	   		elif [ "5432" == $port ]; then
	   			echo $ip >> $results/postgresql.txt
	   		elif [ "5800" = $port ] || [ "5900" = $port ]; then
	   			if [ "0" == $count_vnc ]; then
	   				echo -e "$ip $port,\c" >> $results/vnc.txt
	   				count_vnc=1
	   			else
	   				echo $port >> $results/vnc.txt
	   			fi
	   		elif [ "8009" == $port ]; then
	   			echo $ip >> $results/ajp.txt
	   		elif [ "8080" = $port ] || [ "8081" = $port ] || [ "8443" = $port ] || [ "8090" = $port ]; then
	   			if [ "0" == $count_tomcat ]; then
	   				echo -e "$ip $port,\c" > $results/tomcat.txt 
	   				count_tomcat=1
	   			else
	   				echo $port >> $results/tomcat.txt
	   			fi
	   		fi

		done < ports.txt
	done < $TARGET
	sed -i '/^$/d' $results/http.txt; sed -i '/^$/d' $results/tomcat.txt; sed -i '/^$/d' $results/vnc.txt
	sed -i '/^$/d' $results/oracle.txt; sed -i '/^$/d' $results/mysql.txt; sed -i '/^$/d' $results/ssh.txt
	sed -i '/^$/d' $results/ftp.txt; sed -i '/^$/d' $results/telnet.txt; sed -i '/^$/d' $results/postgresql.txt
	sed -i '/^$/d' $results/mssql.txt	
	echo ""
	echo -e "${greenColour}[*] Saving results in ftp.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in ssh.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in http.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in mssql.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in oracle.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in mysql.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in postgresql.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in vnc.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in ajp.txt ${endColour}"
	sleep 0.5
	echo -e "${greenColour}[*] Saving results in tomcat.txt ${endColour}"
	sleep 0.5
	echo -e "\n${grayColour}[*] Files saving in directory $results ${endColour}"
	sleep 0.5
	ENDTIME=$(date +%s)
	echo -e "\n${yellowColour}It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task, Good Bye :) ${endColour}"

}

#main function

if [ "$(id -u)" == "0" ]; then
declare -i count=0
declare -i count2=0
	while getopts ":i:f:h:" arg; do
		case $arg in
			i) reconIPs=$OPTARG; let count=1 ;;
			f) reconFile=$OPTARG; let count=2 ;;
			h) helpPanel;;

		esac
	done
	if [ $count -eq 1 ] ; then
		StartIPs
	elif [ $count -eq 2 ]; then
		StartFile
	else
		helpPanel	
	fi	
else
	echo ""
fi

