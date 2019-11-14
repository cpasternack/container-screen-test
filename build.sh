#!/usr/bin/env bash

# turn on experimental in docker daemon to use --squash
#docker build --rm --squash -t localhost/screentest:dev .
docker build --rm -t localhost/screentest:dev .
