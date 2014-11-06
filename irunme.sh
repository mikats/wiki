#!/bin/sh

#sudo docker run -it -v $PWD/test:/root/test -p 8080:8090 mikats/wiki bash

sudo docker run -it --name "wiki" \
	-p 80:8090 -p 5432:5432 \
	-v /home/ubuntu/docker/wiki/data/confluence-data:/var/atlassian/application-data/confluence \
	-v /home/ubuntu/docker/wiki/data/confluence-postgresql:/var/data/postgresql \
	-e USER="confluenceuser" \
	-e DB="confluencedb" \
	-e PASS="tstest" \
	mikats/wiki bash
