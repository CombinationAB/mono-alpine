ARG mono_version=6.8.0.96
FROM mono:${mono_version} as mono
FROM alpine:3.11 as base
FROM base as build
ARG mono_version
RUN apk --no-cache add curl
RUN mkdir /build
WORKDIR /build
ENV mono_version=${mono_version}
RUN echo "Mono version: ${mono_version}"
RUN curl -o /build/mono.tar.xz https://download.mono-project.com/sources/mono/mono-${mono_version}.tar.xz
RUN tar --strip-components=1 -C /build -Jxf /build/mono.tar.xz
RUN apk --no-cache add gcc g++ make python3 xz bash autoconf automake libtool musl-dev cmake linux-headers
RUN ./autogen.sh --prefix=/usr --enable-parallel-mark --with-mcs-docs=no --with-sigaltstack=no --disable-mcs-build
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN make -j16
RUN make install

FROM base as runtime
COPY --from=mono /usr/lib/mono/ /usr/lib/mono/
RUN apk --no-cache add libgcc
COPY --from=build /usr/bin/mono /usr/bin/
COPY --from=build /usr/lib/libmono-* /usr/lib/
COPY --from=build /usr/etc/mono/ /usr/etc/mono/
RUN mono --version && mcs --version