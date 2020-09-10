[![Docker Stars](https://img.shields.io/docker/stars/combination/mono-alpine.svg?style=flat-square)](https://hub.docker.com/r/combination/mono-alpine/)
[![Docker Pulls](https://img.shields.io/docker/pulls/combination/mono-alpine.svg?style=flat-square)](https://hub.docker.com/r/combination/mono-alpine/)

# mono-alpine
Alpine build of a more recent Mono version than available from Alpine packages. Bootstrapped using the Alpine package version of mono.

## Versions
* `combination/mono-alpine:6.12.0.93` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/combination/mono-alpine/6.12.0.93)
* `combination/mono-alpine:6.10.0.105` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/combination/mono-alpine/6.10.0.105)
* `combination/mono-alpine:6.8.0.123` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/combination/mono-alpine/6.8.0.123)
* `combination/mono-alpine:6.6.0.161` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/combination/mono-alpine/6.6.0.161)
* `combination/mono-alpine:6.4.0.198` ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/combination/mono-alpine/6.4.0.198)

## Note
This repository builds newer version of Mono from source, patching the [deadlock issue](https://github.com/mono/mono/issues/7167) that prevented Mono from running on Alpine.

