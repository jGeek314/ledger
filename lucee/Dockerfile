FROM ortussolutions/commandbox:lucee5-2.3.0

ARG ENABLE_SSL
ARG SSL_PORT
ARG CERT_FILE
ARG CERT_KEY_FILE
ARG TIER

COPY ./box.json /app/box.json
RUN cd /app && box install

COPY ./config.json /app/config.json

RUN box server set web.SSL.enable=$ENABLE_SSL && \
    box server set web.SSL.port=$SSL_PORT &&\
    if [ "$ENABLE_SSL" = "true" ] ; then box server set web.SSL.certFile=/certs/$CERT_FILE; else echo SSL Not enabled, do not set certFile ; fi &&\
    if [ "$ENABLE_SSL" = "true" ] ; then box server set web.SSL.keyFile=/certs/$CERT_KEY_FILE; else echo SSL Not enabled, do not set keyFile ; fi &&\
    if [ "$TIER" = "prod" ] || [ "$TIER" = "staging" ]; then box server set web.webroot="/app/src"; else box server set web.webroot="/app"; fi 

RUN cd /app && box cfconfig import config.json
