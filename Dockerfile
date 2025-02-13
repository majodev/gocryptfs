FROM golang:alpine AS builder

ENV GOCRYPTFS_VERSION=v2.5.1

RUN apk add bash gcc git libc-dev openssl-dev \
    && mkdir /app

RUN cd /app && git clone https://github.com/rfjakob/gocryptfs.git
WORKDIR /app/gocryptfs

RUN git checkout "$GOCRYPTFS_VERSION"
RUN ./build.bash
RUN mv "$(go env GOPATH)/bin/gocryptfs" /bin/gocryptfs

FROM alpine:latest

ENV MOUNT_OPTIONS="-allow_other -nosyslog"
ENV UNMOUNT_OPTIONS="-u -z"
ENV ENC_PATH="/encrypted"
ENV DEC_PATH="/decrypted"

COPY --from=builder /bin/gocryptfs /usr/local/bin/gocryptfs
RUN apk --no-cache add fuse bash openssl-dev
RUN echo user_allow_other >> /etc/fuse.conf

COPY run.sh run.sh

CMD ["./run.sh"]