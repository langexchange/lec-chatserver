FROM ejabberd/ecs:23.01
USER root

## Install python
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 \
    bash \
    && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

## Install necessary dependencies
COPY --chown=ejabberd ./ejabberd-dev.yml /home/ejabberd/conf/ejabberd.yml
COPY ./auth_script /home/ejabberd/conf/auth_script
COPY --chown=ejabberd ./certificates /home/ejabberd/conf/certificates
RUN chown ejabberd: -R /home/ejabberd/conf/auth_script

RUN pip3 install --no-cache -r ./conf/auth_script/requirements.txt

## Install other dependencies
RUN apk add --update --no-cache vim \
    sudo

## Add script file
RUN touch /home/ejabberd/conf/env.yml
RUN chown ejabberd: /home/ejabberd/conf/env.yml
RUN chmod 771 /home/ejabberd/conf/env.yml

COPY --chown=ejabberd ./script.sh /home/ejabberd/conf/script.sh
RUN chmod 774 /home/ejabberd/conf/script.sh

EXPOSE 5222 5223 5269 5443/tcp 5280/tcp 3478/udp 1883

ENTRYPOINT ["/bin/sh", "-c", "/home/ejabberd/conf/script.sh && /home/ejabberd/bin/ejabberdctl foreground"]