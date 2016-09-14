#
FROM python:3.5-alpine
MAINTAINER https://github.com/muccg

ENV DEVPI_VERSION 4.1.0
ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup -S -g 1000 devpi \
    && adduser -D -S -u 1000 -h /data -s /sbin/nologin -G devpi devpi

# entrypoint is written in bash
RUN apk add --no-cache bash
 
# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install --upgrade --no-cache-dir virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && $VIRTUAL_ENV/bin/pip install $ARG_PIP_OPTS pip==$PYTHON_PIP_VERSION
ENV PATH $VIRTUAL_ENV/bin:$PATH

RUN pip install $ARG_PIP_OPTS \
    "devpi-client==2.6.4" \
    "devpi-web==3.1.1" \
    "devpi-server==$DEVPI_VERSION"

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
