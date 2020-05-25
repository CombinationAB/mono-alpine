FROM alpine:3.11 as base

FROM base as build

ARG mono_version=6.8.0.123
RUN apk --no-cache add curl
RUN mkdir /build
WORKDIR /build
RUN curl -o /build/mono.tar.xz https://download.mono-project.com/sources/mono/mono-${mono_version}.tar.xz
RUN tar --strip-components=1 -C /build -Jxf /build/mono.tar.xz
RUN apk --no-cache add gcc g++ make python3 xz bash autoconf automake libtool musl-dev cmake linux-headers
RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN ./autogen.sh --prefix=/usr --enable-parallel-mark --with-mcs-docs=no --with-sigaltstack=no
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN make -j16
RUN apk --no-cache del mono
RUN make install

FROM base as runtime
RUN apk --no-cache add libgcc
COPY --from=build /usr/bin/mono /usr/bin/
COPY --from=build /usr/lib/libmono-* /usr/lib/
COPY --from=build /usr/etc/mono/ /usr/etc/mono/
COPY --from=build /usr/lib/mono/ /usr/lib/mono/
