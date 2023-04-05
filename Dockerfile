FROM ubuntu:latest

# Build argument to point to correct branch on GitHub
ARG LV_BRANCH=release-1.2/neovim-0.8

# Set environment correctly
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and LunarVim
RUN apt update && apt -y install sudo curl build-essential git bash-completion  -y
COPY . ./.terminal_setup

# Setup LVIM to run on startup
CMD /bin/bash -ci './setup.sh || bash'