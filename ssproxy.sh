#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Install(){
apt-get install python-pip -y
pip install shadowsocks

}

Set_server(){
	
		echo -e "请输入服务器的IP[server]"
		read -e -p "(默认: 127.0.0.1):" server_s
		[[ -z "$server_s" ]] && server_s="127.0.0.1"
	
	echo && echo "	================================================"
	echo -e "	IP[server]: ${Red_background_prefix} ${server_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}

Set_method(){
	
	echo -e "请输入加密方式[method]（字母/数字，不可与其他账号重复）"
	read -e -p "(默认: 取消):" method
	[[ -z "$method" ]] && echo "已取消..." && exit 0
	echo && echo "	================================================"
	echo -e "	加密方式[username]: ${Red_background_prefix} ${method} ${Font_color_suffix}"
	echo "	================================================" && echo
}

Set_port(){
	
	echo -e "请输入port[port]（字母/数字，不可与其他账号重复）"
	read -e -p "(默认: 取消):" port
	[[ -z "$port" ]] && echo "已取消..." && exit 0
	echo && echo "	================================================"
	echo -e "	加密方式[username]: ${Red_background_prefix} ${port} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_password(){
	
		echo -e "请输入服务端中的密码[password]（字母/数字）"
	read -e -p "(默认: 8888):" password_s
	[[ -z "$password_s" ]] && password_s="8888"
	echo && echo "	================================================"
	echo -e "	密码[password]: ${Red_background_prefix} ${password_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}

#download(){
       wget --no-check-certificate -qO client-linux.py 'https://raw.githubusercontent.com/tykgood6/ServerStatus/master/clients/client-linux.py'
       chmod 777 client-linux.py

}

config_ss(){

	echo "
	{
    "server":"${server_s}",
    "server_port":${port},
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"${password_s}",
    "timeout":300,
    "method":"${method}"
}
	" > /etc/ssloacl.json
}


config_privoxy(){

	echo "confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address  127.0.0.1:8118
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 0
forward-socks5   /               127.0.0.1:1080 .   
forwarded-connect-retries  0
accept-intercepted-requests 0
allow-cgi-request-crunching 0
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
	" > /etc/privoxy/config
}

self-start(){
	sed -i "s/exit 0/ /ig" /etc/rc.local
	echo -e "\n/status/run.sh\c" >> /etc/rc.local
	chmod +x /etc/rc.local
}

run(){
 
      bash /status/
      
 

}

install(){
         Set_server
	 Set_method
	 Set_password
	 directory
	 download
	 config
	 self-start
	 run
}

uninstall(){
         ps -ef | grep client-linux | cut -c 9-15| xargs kill -s 9
	 rm -rf /status
	 sed -i '/\/status\/run.sh/d' /etc/rc.local

}


echo -e "${Info} install "
echo -e "1.install\n2.check \n3.uninstall"
read -p "input:" function

while [[ ! "${function}" =~ ^[1-3]$ ]]
	do
		echo -e "${Error} error"
		echo -e "${Info} reinput" && read -p "input:" function
	done

if   [[ "${function}" == "1" ]]; then
	install
elif [[ "${function}" == "2" ]]; then
	echo "fuck"
else
	uninstall
fi
