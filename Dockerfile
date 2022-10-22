FROM confluence-m1:latest

# 将代理破解包加入容器
COPY ".key/atlassian/atlassian-agent-v1.3.1/atlassian-agent.jar" /opt/atlassian/confluence/

COPY "./mysql-connector-java-8.0.22.jar" /opt/atlassian/confluence/confluence/WEB-INF/lib

# 设置启动加载代理包
RUN echo '\nexport CATALINA_OPTS="-javaagent:/opt/atlassian/confluence/atlassian-agent.jar ${CATALINA_OPTS}"' >> /opt/atlassian/confluence/bin/setenv.sh