#!/bin/bash

cp /home/dockeruser/docker/networking/netalertx/data/config/app.conf /home/dockeruser/backups/netalertx/app_conf_$(date +%Y%m%d_%H%M).bak
cp /home/dockeruser/docker/networking/netalertx/data/db/app.db /home/dockeruser/backups/netalertx/app_$(date +%Y%m%d_%H%M).db
