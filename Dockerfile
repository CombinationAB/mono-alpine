ARG mono_version=6.10.0.105
FROM alpine:3.11 as base
RUN apk --no-cache add libgcc ca-certificates
FROM base as build
ARG mono_version
RUN apk --no-cache add curl git
RUN mkdir /build
WORKDIR /build
RUN git clone https://github.com/mono/mono.git
WORKDIR /build/mono
RUN git submodule update --init --recursive
RUN apk --no-cache add gcc g++ make python3 xz bash autoconf automake libtool musl-dev cmake linux-headers gdb strace linux-headers
RUN git fetch && git checkout mono-${mono_version} && git submodule update --init --recursive


RUN ./autogen.sh --prefix=/usr/local --with-mcs-docs=no --with-sigaltstack=no --disable-nls
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir -p /usr/include/sys && touch /usr/include/sys/sysctl.h
RUN sed -i 's/HAVE_DECL_PTHREAD_MUTEXATTR_SETPROTOCOL/0/' mono/utils/mono-os-mutex.h
RUN make -j16
RUN make install
RUN apk del gcc g++ make python3 xz autoconf automake libtool musl-dev cmake linux-headers gdb strace linux-headers curl git bash
RUN rm -rf /usr/local/include && find /usr/local -name \*.a | xargs rm

FROM base as runtime
COPY --from=build /usr/local/ /usr/local/
RUN cert-sync /etc/ssl/certs/ca-certificates.crt && mono --version
