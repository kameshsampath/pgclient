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
# pgsql12-performance-centos8
FROM centos:centos8

LABEL maintainer="Kamesh Sampath<kamesh.sampath@hotmail.com>"

LABEL summary="PostgreSQL 12 Client" \
	description="PostgreSQL 12 Client"

ENV PGVERSION="12"
ENV PGROOT="/usr/pgsql-${PGVERSION}"

ENV APP_DATA="/opt/app-root"

RUN mkdir -p $APP_DATA

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
	&& rpm -Uvh https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
	&& dnf -y update \
	&& dnf -y module disable postgresql \
	&& dnf -y install postgresql12  \
	&& dnf -y clean all

COPY root/ /

RUN /usr/libexec/fix-permissions ${APP_DATA}

COPY ./s2i/bin/ /usr/libexec/s2i

ENTRYPOINT ["/usr/libexec/s2i/run"]
CMD ["--help"]
