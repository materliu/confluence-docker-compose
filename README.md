# 使用说明
利用此docker-compose配置， 迅速的在本地搭建起confluence。

相对 master 分支，有一些修改，首先镜像改为 confluence 官方镜像

## 步骤0 （如果你使用的是mac m1）

本地编译 confluence m1版本

git clone --recurse-submodule https://bitbucket.org/atlassian-docker/docker-atlassian-confluence-server.git

cd docker-atlassian-confluence-server

docker build --tag confluence-m1 --build-arg CONFLUENCE_VERSION=x.x.x .

Note: This method is known to work on Mac M1 and AWS ARM64 machines, but has not be extensively tested.

The simplest method of getting a platform image is to build it on a target machine. The following assumes you have git and Docker installed. You will also need to know which version of Confluence you want to build; substitute CONFLUENCE_VERSION=x.x.x with your required version:

### 注意

如果编译过程中 apt-get 报错，那要考虑是国内网络环境问题导致的，需要替换一下源，找到项目中的 Dockerfile，修改如下部分

ENTRYPOINT ["/usr/bin/tini", "--"]

RUN sed -i 's#http://ports.ubuntu.com#https://mirrors.163.com#g' /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN apt-get clean
RUN apt-get -y update --fix-missing \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends fontconfig fonts-noto python3 python3-jinja2 tini \
    && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

将官方源修改为国内网易的源   

## 步骤1

本地创建 .key/atlassian 目录， 其中放置 atlassian-agent-v1.3.1，研究 confluence 必备的 agent, 本 repository 不做提供，请自行搜索

## 步骤2

docker-compose up -d 在后台启动 所有容器

## 步骤3

浏览器访问 http://localhost:8090 , 记下页面的Server ID，比如说是： BGED-FJRQ-P5AK-5M1A

## 步骤4

docker exec -it confluence_db /bin/bash

创建数据库

mysql -uroot -pconfluence

create database confluence;

create user "materliu"@"%" identified by "confluence";

grant all privileges on confluence.* to "materliu"@"%";

flush privileges;

exit

exit

进入 confluence server

docker exec -it confluence_server /bin/bash

进去之后执行：

java -jar /opt/atlassian/confluence/atlassian-agent.jar -p conf -m materliu@gmail.com -n materliu -o http://localhost:8090 -s BKFN-6H3K-G8YR-A4H5

以上内容针对自己的信息做修改

拿到license，往下走

## 步骤5

选择 own database，Hostname： DB，port：5306，数据表信息根据 docker-compose.yml 中的内容做修改

## 步骤6

接下来就是安装成功之后的一个随意操作了

# FAQ

一、如果安装好以后，使用以前的备份恢复站点，遇到如下错误：

invocation of method 'isshowsignup' in class com.atlassian.confluence.user.actions.loginaction threw exception java.lang.nullpointerexception: application cannot be null at /login.vm

不能登录，则可以参考： https://confluence.atlassian.com/confkb/unable-to-log-in-to-confluence-715261580.html  解决

还有可能是 https://community.atlassian.com/t5/Confluence-questions/Invocation-of-method-isShowSignUp-in-class-com-atlassian/qaq-p/716849

二、restore一直失败

先不要在restore的时候勾选构建索引，先restore，好了之后再单独去构建索引。 还有就是restore的时候多等一些时间，别急着去打扰。mysql镜像的配置，可以把超时时间进一步设长，如本项目中的my.cnf所示。
