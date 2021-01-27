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
For persistence, mount docker volume to `/var/www/html`. If this directory is empty during start, new Grav installation will be created there.
```
docker run --name grav -v data:/var/www/html localhost/grav
```
