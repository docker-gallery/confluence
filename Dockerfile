FROM ubuntu as downloader
RUN apt-get update && apt-get install wget curl -y
ENV CONFLUENCE_VERSION  		6.4.3
ENV MYSQL_CONNECTOR_VERSION		5.1.44
WORKDIR /home
RUN wget -O mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz   https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz
RUN wget -O atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz        http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz
RUN tar -xzf mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz -C ./ \
&& mv ./mysql-connector-java-${MYSQL_CONNECTOR_VERSION} ./mysql-connector-java \
&& tar -xzf atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz -C ./ \
&& mv ./atlassian-confluence-${CONFLUENCE_VERSION} ./atlassian-confluence \
&& rm ./*.tar.gz


FROM openjdk:8

ENV CONFLUENCE_VERSION  		6.4.3
ENV MYSQL_CONNECTOR_VERSION		5.1.44
ENV ATLASSIAN_HOME  			/opt/atlassian
ENV CONFLUENCE_INSTALL    		/opt/atlassian/confluence
ENV CONFLUENCE_HOME     	    /var/atlassian/application-data/confluence
ENV CONFLUENCE_EXPORT           /var/atlassian/application-data/confluence/export
ENV TIME_ZONE 					America/Sao_Paulo

COPY --from=downloader /home/atlassian-confluence ${CONFLUENCE_INSTALL}
COPY --from=downloader /home/mysql-connector-java/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar ${CONFLUENCE_INSTALL}/confluence/WEB-INF/lib/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar

RUN chmod -R u=rwx,go-rwx ${CONFLUENCE_INSTALL} \
&&  mkdir -p ${CONFLUENCE_HOME} \
&&  chmod -R u=rwx,go-rwx ${CONFLUENCE_HOME}

#RUN ls -l ${CONFLUENCE_INSTALL}/bin/
#RUN cat ${CONFLUENCE_INSTALL}/bin/start-confluence.sh  && crash

RUN echo "confluence.home = ${CONFLUENCE_HOME}" > ${CONFLUENCE_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties \
## &&  sed --in-place "s/java version/openjdk version/g" "${CONFLUENCE_INSTALL}/bin/check-java.sh" \
&&  echo "${TIME_ZONE}" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata


EXPOSE 8080 8005
VOLUME ["${CONFLUENCE_HOME}", "${CONFLUENCE_INSTALL}"]
WORKDIR ${CONFLUENCE_INSTALL}/bin/
ENTRYPOINT ["./start-confluence.sh", "-fg"]