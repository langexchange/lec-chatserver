# FROM erlang:25.2.3-slim

# ## Ejabberd dependencies
# RUN apt-get -qq update && apt-get -qq install \
#     autoconf \
#     automake \
#     g++ \
#     gcc \
#     git \
#     libexpat1-dev \
#     libgd-dev \
#     libpam0g-dev \
#     libsqlite3-dev \
#     libssl-dev \
#     libwebp-dev \
#     libyaml-dev \
#     make

# # My app depedencies
# RUN apt-get -qq install \
#     python3 \
#     sudo \
#     vim 

# # Create user ejabberd
# RUN useradd -ms /bin/bash ejabberd && echo "ejabberd:password" | chpasswd && adduser ejabberd sudo
#     # usermod -aG root ejabberd'
# USER ejabberd
# WORKDIR /home/ejabberd

# COPY ejabberd-22.05.tar.gz .
# RUN tar -xzvf ejabberd-22.05.tar.gz \
#     && rm ejabberd-22.05.tar.gz

# WORKDIR /home/ejabberd/ejabberd-22.05
# RUN ./autogen.sh \
#     && ./configure \
#     && make update \
#     && make

# ## Installation
# USER root
# RUN make install

# ## Modify access priviledge
# WORKDIR /usr/local
# RUN chmod -R 755 ./sbin/ejabberdctl \
#     ./var/lib/ejabberd \
#     ./etc/ejabberd

# ## Prepare starting point
# RUN mkdir -p /home/ejabberd/database \
#     /home/ejabberd/database/bin

# RUN mv /home/ejabberd/ejabberd-22.05/sql/* \
#     ./var/lib/ejabberd \
#     ./etc/ejabberd

# USER ejabberd

# ENTRYPOINT ["bash"]

FROM ejabberd/ecs
USER root

## My stack
# COPY --chown=ejabberd ./ conf/

## Install python
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

## Install necessary python dependencies
COPY --chown=ejabberd ./requirements.txt conf/
RUN pip3 install --no-cache -r ./conf/requirements.txt

## Install other dependencies
RUN apk add --update --no-cache vim \
    sudo

EXPOSE 5222 5223 5269 5443/tcp 5280/tcp 3478/udp 1883
