#!/bin/bash
set -e

# Stop the running container (if any)
containerid=sudo docker ps -q
sudo docker rm -f $containerid
