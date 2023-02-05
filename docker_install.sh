# /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 颜色选择
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
font="\033[0m"

# 移出老版本
remove_old_version() {
    sudo yum remove docker \
                    docker-client \
                    docker-client-latest \
                    docker-common \
                    docker-latest \
                    docker-latest-logrotate \
                    docker-logrotate \
                    docker-engine
}

# 更新yum仓库
update_repo() {
    sudo yum install -y yum-utils
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
}

# 安装最新版docker
install_docker() {
    sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl enable docker
}

# 设置开机自启
start_with_system() {
    sudo systemctl start docker
    echo "开机自启设置成功"
}

# 安装docker compose插件
install_docker_compose() {
    sudo yum update
    sudo yum install docker-compose-plugin
}

# 添加国内源
add_docker_repo() {
    touch /etc/docker/daemon.json
    echo "{" > /etc/docker/daemon.json
    echo '    "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]' >> /etc/docker/daemon.json
    echo "}" >> /etc/docker/daemon.json
}

echo -e "${yellow} CentOS docker一键安装脚本 ${font}"
echo -e "${green} 1.一键移除老版本 ${font}"
echo -e "${green} 2.安装最新版docker ${font}"
echo -e "${green} 3.设置开机自启 ${font}"
echo -e "${green} 4.安装docker compose插件 ${font}"
echo -e "${green} 5.添加国内源 ${font}"
# echo -e "${green} 6.一键设置上述所有选项（不含安装） ${font}"
start_menu(){
    read -p "请输入数字(1-5),选择你要进行的操作:" num
    case "$num" in
        1)
            remove_old_version
        ;;
        2)
            remove_old_version
            update_repo
            install_docker
        ;;
        3)
            start_with_system
        ;;
        4)
            install_docker_compose
        ;;
        5)
            add_docker_repo
        ;;
        *)
        echo -e "${red} 请输入正确的数字 (1-3) ${font}"
        ;;
    esac
	}

# 运行开始菜单
start_menu