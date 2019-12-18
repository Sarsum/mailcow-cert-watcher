FROM docker:latest

RUN apk add --update \
  && apk add --no-cache inotify-tools \
  bash \
  && mkdir -p /ssl-folder

COPY watcher.sh /

RUN chmod +x /watcher.sh

CMD /watcher.sh