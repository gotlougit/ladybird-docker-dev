# Shows all the available commands to run
default:
	just -l
# Builds and runs Ladybird through container (first time setup if necessary)
run:
    ./container.sh run
# Builds and runs Ladybird through container in gdb (first time setup if necessary)
gdb:
    ./container.sh gdb
# Opens shell inside container (first time setup if necessary)
sh:
    ./container.sh sh
# Builds/updates Docker container
docker:
    ./container.sh docker
# Runs python http server inside the ladybird repo to run scripts locally in Ladybird
serve:
    docker exec -it ladybird_dev_container /bin/bash -c "cd /app && python3 -m http.server"
