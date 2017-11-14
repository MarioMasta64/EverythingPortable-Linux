#!/bin/sh

clear

if [ ! -d ./home/ ]; then 
	mkdir ./home/
fi

if [ ! -d ./extra/ ]; then 
	mkdir ./extra/
fi

make_temp_dir() {
	if [ ! -d ./temp/ ]; then 
		mkdir ./temp/
	fi
}

remove_temp_dir() {
	if [ -d ./temp/ ]; then
		rm -r -f ./temp/
	fi
}

check_wget() {
	if [ ! -f ./bin/wget ]; then
		download_wget
	fi
}

download_wget() {
	curl https://web.archive.org/web/20100514091027/http://ftp.gnu.org/gnu/wget/wget-latest.tar.gz -o ./extra/wget-latest.tar.gz
	extract_wget
	remove_temp_dir
}

extract_wget() {
	make_temp_dir
	if [ -f ./bin/pv ]; then
		./bin/pv ./extra/wget-latest.tar.gz | tar zxC ./temp/
		build_wget
	else
		download_pv
		extract_wget
	fi
}

build_wget() {
	./temp/wget-1.12/configure --prefix=$PWD && make && make install
}

check_pv() {
	if [ ! -f ./bin/pv ]; then
		download_pv
	fi
}

download_pv() {
	echo pv downloader not implemented
}

check_java() {
	if [ -f ./bin/java ]; then
		java -version
	 else
		download_java
		check_java
	 fi
}

download_java() {
	if [ "$arch" = "64" ]; then
		./bin/wget -O ./extra/jre-8u151-linux-x64.tar.gz http://old-school-gamer.tk/misc/jre-8u151-linux-x64.tar.gz
	else
		./bin/wget -O ./extra/jre-8u151-linux-i586.tar.gz http://old-school-gamer.tk/misc/jre-8u151-linux-i586.tar.gz
	fi
	remove_temp_dir
	extract_java
}

extract_java() {
	make_temp_dir
	if [ "$arch" = "64" ]; then
		./bin/pv ./extra/jre-8u151-linux-x64.tar.gz | tar zxC $PWD/temp/;
	else
		./bin/pv ./extra/jre-8u151-linux-i586.tar.gz | tar zxC $PWD/temp/;
	fi
	copy_java
}

copy_java() {
	if [ -d ./temp/jre1.8.0_151/ ]; then
		cp -rp ./temp/jre1.8.0_151/* ./
	fi
}

check_os() {
	export arch="$(getconf LONG_BIT)"
}

check_minecraft() {
	if [ ! -f ./home/Minecraft.jar ]; then
		./bin/wget -O ./home/Minecraft.jar http://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar
		check_minecraft
	else
		cd ./bin/
		java -jar -Duser.home=$PWD/../home ../home/Minecraft.jar
	fi
}

init() {
	remove_temp_dir
	check_wget
	check_pv
	check_os
	check_java
	echo $arch
	echo $PATH
	echo $HOME
	check_java
}

main_menu() {
	
	while true
	do
		clear
		echo "~~~~~~~~~~~~~~~~~~~~~"	
		echo " M A I N - M E N U"
		echo "~~~~~~~~~~~~~~~~~~~~~"
		echo "1. Start Minecraft"
		echo "2. Exit"
		echo "~~~~~~~~~~~~~~~~~~~~~"
		local choice
		read -p "Enter choice [ 1 - 2] " choice
		case $choice in
			1) check_minecraft ;;
			2) exit 0;;
			*) echo -e "${RED}Error...${STD}" && sleep 2
		esac
	done
}

init
main_menu