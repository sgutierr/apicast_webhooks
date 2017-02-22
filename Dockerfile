# This is an example of adding APICAST modifications

FROM quay.io/3scale/apicast:v3.0.0-alpha2

USER root

# If I do not run this, nginx gives an error while booting...
RUN rm -rf /opt/app-root/src/logs

USER default

# Copy LUA source code to the appropriate directory
COPY /webhooks /opt/app-root/src/src/
WORKDIR /opt/app-root/src/src/

COPY /conf/webhooks.conf /opt/app/sites.d

WORKDIR /opt/app-root
