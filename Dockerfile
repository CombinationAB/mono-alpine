ARG mono_version=6.8.0.96
FROM mono:${mono_version} as mono
FROM alpine:3.11 as base
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


RUN ./autogen.sh --prefix=/usr --with-mcs-docs=no --with-sigaltstack=no --disable-nls
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir -p /usr/include/sys && touch /usr/include/sys/sysctl.h
RUN sed -i 's/HAVE_DECL_PTHREAD_MUTEXATTR_SETPROTOCOL/0/' mono/utils/mono-os-mutex.h
RUN make -j16
RUN make install

FROM base as runtime
COPY --from=mono /usr/lib/mono/ /usr/lib/mono/
RUN apk --no-cache add libgcc
COPY --from=build /usr/bin/mono /usr/bin/
COPY --from=build /usr/bin/mcs /usr/bin/
COPY --from=build /usr/lib/libmono-* /usr/lib/
COPY --from=build /usr/etc/mono/ /usr/etc/mono/
RUN mono --version
