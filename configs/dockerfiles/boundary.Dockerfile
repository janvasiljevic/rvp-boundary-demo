FROM hashicorp/boundary:0.11

RUN apk add socat

COPY run.sh run.sh

CMD ["sh", "run.sh"]
