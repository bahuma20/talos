FROM ubuntu:latest

EXPOSE 25565/tcp
EXPOSE 25565/udp

WORKDIR /app
RUN apt update && \
    apt upgrade -y && \
    apt install -y wget curl && \
    wget -O lazymc https://github.com/timvisee/lazymc/releases/download/v0.2.11/lazymc-v0.2.11-linux-x64 && \
    chmod a+x ./lazymc
COPY start-server.sh lazymc.toml entrypoint.sh /app/
ENTRYPOINT /app/entrypoint.sh
