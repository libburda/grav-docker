# Docker image for Grav CMS

[![Build Status](https://cloud.drone.io/api/badges/liborburda/grav-docker/status.svg)](https://cloud.drone.io/liborburda/grav-docker)

This image allows you to run Grav CMS in Docker.

## Build
```
docker build -t grav .
```

## Run
```
docker run --name grav liborburda/grav:latest
```

## Persistent storage
Persistent directory for `user` data is located in /var/lib/grav/user-data.
This directory is symlinked to `/var/www/html/user` during startup.

During first start, default content of `user` directory is copied
to this persistent directory (only if it's not empty).
```
docker run --name grav -v data:/var/lib/grav/user-data liborburda/grav:latest
```
