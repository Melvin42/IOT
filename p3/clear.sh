#!/bin/bash

k3d cluster stop mycluster
k3d cluster delete mycluster
docker rmi $(sudo docker image ls -aq)

