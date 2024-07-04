# Shows all the available commands to run
default:
	just -l
# Builds and runs Ladybird through container (first time setup if necessary)
run:
    ./container.sh
# Opens shell inside container (first time setup if necessary)
sh:
    ./container.sh sh
# Builds/updates Docker container
docker:
    ./container.sh docker
