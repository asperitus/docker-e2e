#!/usr/bin/env bash

#
set -x

#docker pull asperitus/e2e

# behind corporate firewall - http_proxy host needs to be ip address
# e.g. export http_proxy=http://10.10.10.10:8080

[ -z "$http_proxy" ] && proxy="" || proxy="-e http_proxy=$http_proxy -e https_proxy=$http_proxy"

#
docker run $proxy -it --rm --privileged --name asperitus-e2e-test -p 8080:8080 -e SECRET_KEY=123 -v /dev/shm:/dev/shm asperitus/e2e