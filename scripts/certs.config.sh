#!/bin/bash -x 

BASEPATH=${BASEPATH-/opt/deploy/}

if [[ ! -d "$BASEPATH" ]] || [[ ! -f "$BASEPATH/docker-compose.yml" ]]  ; then
	echo "'$BASEPATH' is not a valid compose root"
	exit 1
fi

cd $BASEPATH

cat <<END | tee certs/default.conf
upstream kong {
  server apigw:8000;
}

server {
    listen 443;
    server_name  $1;

    ssl on;
    ssl_certificate /certs/live/$1/fullchain.pem;
    ssl_certificate_key /certs/live/$1/privkey.pem;

    location / {
        proxy_pass http://kong;
        proxy_redirect off;
    }
}

server {
    listen 80;
    server_name $1;
    return 301 https://\$server_name\$request_uri;
}
END
