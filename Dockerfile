FROM ubuntu:14.04
MAINTAINER Mika Eriksson
ENV REFRESHED_AT 2014-11-06

# Set correct environment variables.
ENV HOME /root

# Install Java
RUN apt-get -y update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java7-installer

# Install confluence
# 1. download the archive
RUN wget -O /tmp/confluence.bin http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.4.4-x64.bin
# 2. make it executable
RUN chmod u+x /tmp/confluence.bin
# 3. set the response.varfile of the installer for offline and quiet installation
ADD response.varfile /tmp/response.varfile
# 4. run the installer 
RUN /tmp/confluence.bin -q -varfile /tmp/response.varfile
###VOLUME ["/var/atlassian/application-data/confluence"]
EXPOSE 8090

# Ensure UTF-8
RUN apt-get update
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Install the latest postgresql
###RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" > /etc/apt/sources.list.d/pgdg.list &&\
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty universe" > /etc/apt/sources.list.d/pgdg.list &&\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 && \
    /etc/init.d/postgresql stop

# Install useful other tools.
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y pwgen inotify-tools

# Decouple our data from our container.
VOLUME ["/var/data/postgresql"]

# Configure the database to use our data dir
RUN sed -i -e"s/data_directory =.*$/data_directory = '\/var\/data\/postgresql'/" /etc/postgresql/9.3/main/postgresql.conf
# Allow connections from anywhere.
RUN sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host    all    all    0.0.0.0/0    md5" >> /etc/postgresql/9.3/main/pg_hba.conf

EXPOSE 5432
ADD scripts /scripts
RUN chmod +x /scripts/start*.sh
RUN touch /firstrun

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cp -f /scripts/start.sh /etc/my_init.d

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]



