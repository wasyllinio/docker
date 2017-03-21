FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=secret
#    MYSQL_ALLOW_EMPTY_PASSWORD=yes

COPY custom.cnf /etc/mysql/conf.d/
RUN chmod 755 /etc/mysql/conf.d/custom.cnf
