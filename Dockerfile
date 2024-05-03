FROM fedora:40 AS base_img
MAINTAINER Keith Ó Dúlaigh
ARG WILDFLY_VERSION=32.0.0.Final
ARG PGJDBC_VERSION=42.7.3

RUN useradd wildfly
WORKDIR /home/wildfly
RUN dnf upgrade -yy && dnf install java-17-openjdk -yy 
USER wildfly
RUN curl -L "https://github.com/wildfly/wildfly/releases/download/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.tar.gz" -o wildfly-${WILDFLY_VERSION}.tar.gz && tar -xzvf wildfly-${WILDFLY_VERSION}.tar.gz && rm wildfly-${WILDFLY_VERSION}.tar.gz

FROM base_img
WORKDIR wildfly-${WILDFLY_VERSION}
RUN curl -L "https://jdbc.postgresql.org/download/postgresql-${PGJDBC_VERSION}.jar" -o standalone/deployments/postgresql-${PGJDBC_VERSION}.jar
EXPOSE 8080
EXPOSE 9990
COPY standalone.xml /home/wildfly/wildfly-32.0.0.Final/standalone/configuration/standalone.xml
CMD bin/standalone.sh