FROM centos:centos6
MAINTAINER Mika Eriksson
ENV REFRESHED_AT 2014-11-06

RUN yum -y update && yum clean all


