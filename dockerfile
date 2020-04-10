FROM ubuntu:latest
WORKDIR /usr/src/app
RUN apt update && apt full-upgrade -y && apt install -y git curl build-essential libssl-dev zlib1g-dev
RUN git clone https://github.com/TelegramMessenger/MTProxy
RUN cd MTProxy && make

FROM ubuntu:latest
RUN apt update && apt install -y curl
WORKDIR /MTProxy
COPY --from=0 /usr/src/app/MTProxy/objs/bin/mtproto-proxy .
COPY entrypoint.sh .
RUN curl -s https://core.telegram.org/getProxySecret -o proxy-secret && curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
EXPOSE 443
ENTRYPOINT ["./entrypoint.sh"]
