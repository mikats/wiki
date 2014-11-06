FROM centos:centos6
MAINTAINER Mika Eriksson
ENV REFRESHED_AT 2014-11-06

RUN yum -y update && yum clean all
RUN yum -y  install tar
ADD atlassian-confluence-5.6.4-x64.bin atlassian-confluence-5.6.4-x64.bin
ADD response.varfile response.varfile
RUN ./atlassian-confluence-5.6.4-x64.bin -q -varfile response.varfile
EXPOSE 8090





