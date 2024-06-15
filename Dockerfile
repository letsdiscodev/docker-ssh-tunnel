FROM alpine:latest
RUN apk add --update --no-cache openssh
WORKDIR /root
COPY tunnel.sh /root/.
CMD ["./tunnel.sh"]
