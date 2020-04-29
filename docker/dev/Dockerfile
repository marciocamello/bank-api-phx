# IMAGe
FROM elixir:1.10

# MAINTAINER
LABEL Maintainer="Marcio Camello <mac3designer@gmail.com>" \
      Description="BankAPI Elixir image with Phoenix Framework"

# ADDING DEPENDENCIES
RUN apt-get update && apt-get install git inotify-tools make gcc libc-dev -y

# APPLICATION DIRECTORY
RUN mkdir /app
WORKDIR /app

# INSTALL MIX DEPENDENCIES
RUN mix local.hex --force && \
    mix local.rebar --force

# PORT
ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

# CLEAR CACHE
RUN rm -rf /var/cache/* \
    && rm -rf /tmp/*

COPY entrypoint.sh /root/entrypoint.sh
RUN chown root:root /root/entrypoint.sh

# START
CMD [ "bash", "-c", "/root/entrypoint.sh" ]