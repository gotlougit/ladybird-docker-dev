#!/usr/bin/env bash

# Sets up a Docker container from which you can both build and run Ladybird
# It passes in a Wayland socket for this purpose

set -e

ARG0=$0
print_help() {
    NAME=$(basename "$ARG0")
    cat <<EOF
Usage: $NAME [COMMAND]
       Sets up ephemeral Docker containers for Ladybird dev
  Examples:
    $NAME run
        Runs "./Meta/ladybird.sh run ladybird" inside the container, passing a Wayland socket
    $NAME sh
        Opens a bash shell inside the container
    $NAME docker
        Sets up the Docker container/updates it if already installed
    $NAME help
        Shows this help screen
EOF
}

usage() {
    >&2 print_help
    exit 1
}

docker_setup() {
    local should_upgrade="$1"
    
    OLDID=$(docker images ladybird-dev -q)
    if [ -z "${OLDID}" ]; then
        echo "Building image from Dockerfile..."
        docker build -f ./Dockerfile . -t ladybird-dev
    elif [ "$should_upgrade" = "true" ]; then
        echo "Removing old image..."
        docker image rm ladybird-dev:latest
        echo "Building new image from Dockerfile..."
        docker build -f ./Dockerfile . -t ladybird-dev
    fi
}

CMD=$1
CONTAINER_CMD="./Meta/ladybird.sh run ladybird"
if [ "$CMD" = "docker" ]; then
    docker_setup "true"
    exit 0
elif [ "$CMD" = "sh" ]; then
    CONTAINER_CMD="bash"
elif [ "$CMD" != "run" ]; then
    print_help
    exit 0
fi

# Build docker image if not installed already
docker_setup "false"

# Set up the directories to be mounted to the container
if [ ! -d "$(pwd)/.vcpkg" ]; then
    mkdir "$(pwd)/.vcpkg"
fi

if [ ! -d "$(pwd)/.ccache" ]; then
    mkdir "$(pwd)/.ccache"
fi

if [ ! -d "$(pwd)/ladybird" ]; then
    echo "Ladybird source tree not found, cloning..."
    git clone https://github.com/ladybirdbrowser/ladybird
fi

# Pass in Wayland socket from host to container, so you can run the browser
# from the container itself
TMP_DIR=$(mktemp --directory)

is_rootless=$(docker info -f "{{println .SecurityOptions}}" | grep rootless)
if [ -z "$is_rootless" ]; then
    echo "ERROR: attempting to use script with rootful Docker"
    echo "This is a security risk, aborting"
    exit 1
fi

# HACK: Allow root if running in rootless container
# WARNING: DON'T do this with normal Docker, ony rootless Docker or Podman
cd ladybird
git restore Meta/shell_include.sh
git apply --reject --whitespace=fix --ignore-space-change --ignore-whitespace \
    ../allow_root_if_docker.patch 2> /dev/null
cd ..

docker run --rm -it \
    --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    -e XDG_RUNTIME_DIR="${TMP_DIR}" \
    -e WAYLAND_DISPLAY="${WAYLAND_DISPLAY}" \
    --mount type=bind,source="$(pwd)/ladybird",target=/app \
    --mount type=bind,source="$(pwd)/.vcpkg",target=/root/.vcpkg \
    --mount type=bind,source="$(pwd)/.ccache",target=/root/.ccache \
    --hostname "ladybird-dev-container" \
    -v "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}":"${TMP_DIR}/${WAYLAND_DISPLAY}" \
    ladybird-dev:latest bash -c \
    "cd /app && ${CONTAINER_CMD}"

# Switch it back to before we changed stuff up
# This CAN result in data loss if you're working on shell_include.sh
cd ladybird
git restore Meta/shell_include.sh
cd ..
