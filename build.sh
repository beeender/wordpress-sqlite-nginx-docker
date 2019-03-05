#!/bin/bash
set -e

DOCUMENT_ROOT=$1

if [ ! -z "$(ls -A $DOCUMENT_ROOT)" ]; then
   echo "$DOCUMENT_ROOT is not empty!"
   exit -1
fi

curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzvf wordpress.tar.gz --strip-components=1 --directory ${DOCUMENT_ROOT}
curl -o sqlite-plugin.zip https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip
unzip sqlite-plugin.zip -d ${DOCUMENT_ROOT}/wp-content/plugins/
cp ${DOCUMENT_ROOT}/wp-content/plugins/sqlite-integration/db.php ${DOCUMENT_ROOT}/wp-content
cp ${DOCUMENT_ROOT}/wp-config-sample.php ${DOCUMENT_ROOT}/wp-config.php
sed -i "s/<?php/<?php\ndefine('DB_DIR', '\/var\/wordpress\/database\/');/" ${DOCUMENT_ROOT}/wp-config.php

# https detect patch based on HTTP_X_FORWARDED_PROTO for nginx
sed -i "s/<?php/<?php\nif (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') { \$_SERVER['HTTPS'] ='on'; }/" ${DOCUMENT_ROOT}/wp-config.php 

#docker build -t "beeender/wordpress-sqlite-nginx-docker"
# From the old script. Remember to cp those things
#ExecStart=/usr/bin/docker run -p 80:80 -v /var/wordpress/database:/var/wordpress/database -v /var/wordpress/uploads:/usr/share/nginx/html/wp-content/uploads -v /var/wordpress/themes:/usr/share/nginx/html/wp-content/themes -v /var/wordpress/plugins:/usr/share/nginx/html/wp-content/plugins  --name wordpress_server beeender/wordpress-sqlite-nginx-docker:latest

