# used for the ci-dind conatiner
FROM ubuntu:focal

RUN set -x \
        ## Install git and docker
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y git docker.io
