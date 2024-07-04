FROM ubuntu:latest
RUN apt update
RUN apt upgrade
RUN apt -y install g++ lsb-release git python3 autoconf autoconf-archive automake build-essential cmake libavcodec-dev libgl1-mesa-dev ninja-build qt6-base-dev qt6-tools-dev-tools qt6-multimedia-dev qt6-wayland ccache fonts-liberation2 zip unzip curl tar
