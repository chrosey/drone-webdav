FROM alpine
MAINTAINER ViViDboarder <ViViDboarder@gmail.com>

RUN apk -Uuv add curl ca-certificates bash
COPY push.sh /bin/
RUN chmod +x /bin/push.sh

ENTRYPOINT /bin/push.sh
