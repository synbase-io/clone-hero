# Nutze das offizielle Debian-Image
FROM debian:buster-slim AS base
WORKDIR /usr/src/app
ENV DEBIAN_FRONTEND=noninteractive
ENV CLONE_HERO_VERSION=V1.0.0.4080
ENV CLONE_HERO_SERVER_NAME=Synbase

RUN apt-get update
RUN apt-get install -y wget unzip ca-certificates curl jq libicu63 libgssapi-krb5-2

# Lade Server herunter und bereite Daten vor
FROM base AS build
WORKDIR /usr/src/app

# Lade CloneHero Server herunter
RUN mkdir ./download
WORKDIR /usr/src/app/download
RUN wget -qO ./server.zip https://github.com/clonehero-game/releases/releases/download/$CLONE_HERO_VERSION/CloneHero-standalone_server.zip
RUN unzip ./server.zip
RUN rm ./server.zip
WORKDIR /usr/src/app

# Kopiere Server für Debian
RUN mv ./download/**/linux-x64/* .
RUN rm -r -f ./download
RUN chmod +x ./Server

# Kopiere ausführbare Datei
COPY ./startup.sh ./startup.sh
RUN chmod +x ./startup.sh

FROM base
WORKDIR /usr/src/app

COPY --from=build /usr/src/app /usr/src/app

EXPOSE 14242/udp
ENTRYPOINT [ "./startup.sh" ]
