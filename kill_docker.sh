#!/bin/bash

docker container kill $(docker container list -q)
