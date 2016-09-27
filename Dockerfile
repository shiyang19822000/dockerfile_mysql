FROM ubuntu:14.04

# 安装MySQL 5.6，因为笔者需要使用GTID
RUN apt-get update \
    && apt-get install -y mysql-server-5.6

# 清空apt-get的cache以及MySQL datadir
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /var/lib/mysql

# 使用精简配置，主要是为了省内存，笔者机器至少要跑6个MySQL
ADD my.cnf /etc/mysql/my.cnf

# 这里主要是给mysql_install_db脚本使用
ADD my-default.cnf /usr/share/mysql/my-default.cnf

# 增加启动脚本
ADD start.sh /start.sh
RUN chmod +x /start.sh

# 将MySQL datadir设置成可外部挂载
VOLUME ["/var/lib/mysql"]

# 导出3306端口
EXPOSE 3306

# 启动执行start.sh脚本
CMD ["/start.sh"]
