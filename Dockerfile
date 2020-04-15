# The MIT License (MIT)
#
# Copyright (c) 2020 Jesper Pedersen <jesper.pedersen@redhat.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
FROM centos/s2i-core-centos7

LABEL maintainer="Kamesh Sampath<kamesh.sampath@hotmail.com>"

LABEL summary="PostgreSQL 12 Client" \
	description="PostgreSQL 12 Client" \
	io.openshift.expose-services="8080:http" \
	io.openshift.tags="postgres12,client,pgbadger,html,nginx"

ENV PGVERSION="12"
ENV NGINX_VERSION=1.6.3
ENV PGROOT="/usr/pgsql-${PGVERSION}"

ENV APP_DATA="/opt/app-root"

COPY root/ /

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& rpm -Uvh https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
	&& yum -y update \
	&& yum -y install java-1.8.0-openjdk postgresql12 postgresql12-server postgresql12-contrib postgresql12-libs crontabs nss_wrapper gettext bind-utils pgbadger \
	&& yum install -y epel-release \
	&& yum install -y --setopt=tsflags=nodocs nginx \
	&& yum -y clean all

RUN mkdir -p /opt/sql /opt/pgtools

COPY pgtools/ /opt/pgtools/

RUN usermod -a -G root postgres

RUN sed -i 's/80/8080/' /etc/nginx/nginx.conf \
	&& sed -i 's/user nginx;//' /etc/nginx/nginx.conf

#clear dangling refreces

RUN /usr/libexec/fix-permissions /usr/share/nginx \
	&& /usr/libexec/fix-permissions /var/log/nginx \
	&& /usr/libexec/fix-permissions /var/lib/nginx
RUN touch /run/nginx.pid 
RUN /usr/libexec/fix-permissions /run/nginx.pid \
	&& /usr/libexec/fix-permissions /etc/nginx \
	&& /usr/libexec/fix-permissions /opt/pgtools \
	&& /usr/libexec/fix-permissions /opt/sql \
	/usr/libexec/fix-permissions ${APP_DATA}

VOLUME [ "/usr/share/nginx","/opt/sql" ]

EXPOSE 8080

USER 26

ENTRYPOINT ["/usr/bin/entrypoint-run"]
