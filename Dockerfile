FROM alpine:latest AS builder

WORKDIR /usr/local/src
COPY mama-s-toolkit .

RUN apk add --no-cache \
    go \
    libcap

RUN go build -o mama-toolkit ./cmd/mama-toolkit &&\
    setcap cap_net_bind_service=+ep ./mama-toolkit

FROM alpine:latest

WORKDIR /opt/mama-toolkit

RUN chown 1000:1000 /opt/mama-toolkit

USER 1000

COPY --from=builder /usr/local/src/mama-toolkit .


ENTRYPOINT /opt/mama-toolkit/mama-toolkit --webhook=$LUNAR_ADMIN_WEBHOOK
