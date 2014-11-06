#!/bin/sh

if [ ! -d "${PWD}/data" ]; then
    mkdir -p ${PWD}/data/confluence-data
    mkdir -p ${PWD}/data/confluence-postgresql
    touch ${PWD}/data/confluence-data/firstrun
fi

sudo docker run -d --name "wiki" \
	-p 80:8090 -p 5432:5432 \
	-v ${PWD}/data/confluence-data:/var/atlassian/application-data/confluence \
	-v ${PWD}/data/confluence-postgresql:/var/data/postgresql \
	-e DB="confluence" \
	-e USER="cuser" \
	-e PASS="tstest" \
	mikats/wiki
