FROM debian:latest

# Build argument to point to correct branch on GitHub
ARG LV_BRANCH=release-1.2/neovim-0.8
ARG TERM=xterm-256color

# Set environment correctly
ENV DEBIAN_FRONTEND=noninteractive
ARG LV_BRANCH=${LV_BRANCH}
ENV TERM=${TERM}
ENV UP_TO_DATE="up to date"

RUN apt update && \
 apt upgrade -y && \
 apt -y install sudo procps git bash-completion curl wget tree zip build-essential libssl-dev libffi-dev apt-utils

# Install dependencies and LunarVim
COPY . /root/.terminal_setup
WORKDIR /root
# Setup LVIM to run on startup
CMD /bin/bash -ci 'cd ./.terminal_setup && ./setup.sh -I; bash'