FROM centos:7.6.1810 as builder

RUN echo "Adding username [axway] to the system." && \
    groupadd -r axway && \
    useradd -r -g axway axway && \
    mkdir -p /opt/axway/FlowCentral/runtime && \
    mkdir -p /opt/axway/FlowCentral/logs && \
    mkdir -p /opt/axway/FlowCentral/conf/license && \
    mkdir -p /opt/axway/configs && \
    mkdir -p /opt/axway/FlowCentral/resources && \
    mkdir -p /opt/axway/FlowCentral/conf/schemas/storage/ && \
    mkdir -p /opt/axway/FlowCentral/data/keys/com.axway.nodes.ume && \
    mkdir -p /home/axway && \
    chown -R axway:axway /home/axway && \
    chmod -R 777 /home/axway && \
    chmod -R 777 /opt/axway


# install FC OS prerequisites
RUN yum install --quiet -y wget unzip

ARG FC_URL="http://swf-artifactory.lab1.lab.ptx.axway.int/artifactory/com.axway.cg-snapshot/com/axway/products/ume/fc/ume-product-opnode-flowcentral-distrib/"

# SNAPSHOT VERSION OR RELEASE NUMBER
ARG FC_RELEASE_TYPE="<fc_release_type>"
# FC ARTIFACT
ARG FC_ARTIFACT="<fc_artifact>"

RUN wget -nc -r --accept "*zip" --level 1 -nH --cut-dirs=100 "$FC_URL$FC_RELEASE_TYPE$FC_ARTIFACT" -P /home/axway/FC_KIT && \
    unzip /home/axway/FC_KIT/$FC_ARTIFACT -d /opt/axway/FlowCentral/ 
    
FROM openjdk:8u212-jdk-alpine

RUN apk add -q shadow && \
    groupadd axway && \
    adduser -D -u 1000 -h /opt/axway -g '' -G axway axway && \
    apk upgrade --no-cache && \
    apk del shadow wget netcat && \
    apk del shadow && \
    ulimit -S -u 5000

COPY --from=builder  --chown=axway:axway /opt/axway/ /opt/axway/

RUN chmod -R u+x /opt/axway && \
    chgrp -R 0 /opt/axway && \
    chmod -R g=u /opt/axway /etc/passwd && \
    rm -rf /var/cache/apk/* /usr/bin/nc /usr/bin/wget /usr/bin/vi /usr/bin/passwd /usr/bin/nslookup /usr/bin/hexdump /sbin/ip* /sbin/if* /sbin/lsmod /sbin/modprobe /sbin/arp /sbin/route /sbin/apk /sbin/insmod /bin/chmod /bin/chown /bin/ed

USER 1001

COPY ./resources/conf_to_import.txt /opt/axway/FlowCentral/conf.properties
COPY ./scripts/start.sh /opt/axway/scripts/start.sh
COPY ./bin/uid_entrypoint /opt/axway/bin/uid_entrypoint

ENTRYPOINT [ "/opt/axway/bin/uid_entrypoint" ]

WORKDIR /opt/axway/FlowCentral

CMD ["/opt/axway/scripts/start.sh"]

HEALTHCHECK --interval=1m \
            --timeout=5s \
            --start-period=1m \
            --retries=3 \
            CMD java -jar opcmd.jar status
