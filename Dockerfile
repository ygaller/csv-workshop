FROM sportebois/container-tools
MAINTAINER Yair Galler <yairg@leadspace.com>

RUN apt-get -y update && \
    apt-get install -y mysql-client-5.5 mysql-common mysql-server python-dev libmysqlclient-dev && \
    pip install MySQL-python

ADD ./Profile.xls Profile.xls
ADD ./commands.sh commands.sh
ADD ./init_mysql.sh init_mysql.sh


