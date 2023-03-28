#!/bin/bash

# Define the path and filename for the YAML filei

# touch /home/ejabberd/conf/env.yml
# chown ejabberd: /home/ejabberd/conf/env.yml
# chmod 771 /home/ejabberd/conf/env.yml

YAML_FILE="/home/ejabberd/conf/env.yml"
# YAML_FILE="./env.yml"

# whoami
# ls -l /home/ejabberd/conf/env.yml
# Start the YAML document with the opening tag
printf "sql_type: $DB_TYPE\n" > $YAML_FILE
printf "sql_server: \"$DB_SERVER\"\n" >> $YAML_FILE
printf "sql_port: $(expr $DB_PORT + 0)\n" >> $YAML_FILE
printf "sql_database: \"$DB_NAME\"\n" >> $YAML_FILE
printf "sql_username: \"$DB_USER\"\n" >> $YAML_FILE
printf "sql_password: \"$DB_PASSWORD\"\n" >> $YAML_FILE
printf "hosts: [$EJABBERD_HOST]" >> $YAML_FILE

# Close the YAML document with the closing tag

