FROM ubuntu:latest
RUN apt update -y
RUN apt install -y lsb-release gnupg wget
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN wget -O /usr/share/keyrings/llvm-snapshot.gpg.key https://apt.llvm.org/llvm-snapshot.gpg.key
RUN echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/kitware.list
RUN echo "deb [signed-by=/usr/share/keyrings/llvm-snapshot.gpg.key] https://apt.llvm.org/$(lsb_release -sc)/ llvm-toolchain-$(lsb_release -sc)-18 main" | tee -a /etc/apt/sources.list.d/llvm.list
RUN apt update -y
RUN apt upgrade -y 
RUN apt install cmake -y
RUN apt install clang-18 clangd-18 clang-format-18 clang-tidy-18 lld-18 -y
RUN apt install autoconf autoconf-archive automake build-essential ccache cmake curl fonts-liberation2 git libavcodec-dev libavformat-dev libavutil-dev libgl1-mesa-dev nasm ninja-build pkg-config qt6-base-dev qt6-tools-dev-tools qt6-wayland tar unzip zip -y
RUN apt install libpulse-dev qt6-multimedia-dev -y
RUN apt install python3-pip -y
