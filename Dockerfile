FROM debian:latest

# Build argument to point to correct branch on GitHub
ARG TERM="xterm-256color"

# Set environment correctly
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=${TERM}
ENV UP_TO_DATE="up to date"

RUN apt update && \
    apt upgrade -y && \
    apt -y install sudo procps file git bash-completion curl wget tree zip build-essential libssl-dev libffi-dev apt-utils iputils-ping locales ripgrep

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

# Install dependencies and LunarVim
COPY . /root/.terminal_setup
WORKDIR /root
# Setup LVIM to run on startup
CMD /bin/bash -ci 'cd ./.terminal_setup && ./setup.sh -I; bash'