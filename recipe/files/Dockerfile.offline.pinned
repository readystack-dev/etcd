# GENERATED L-009 hermetic build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases from BASE_IMAGE_DIGESTS.lock; vendored Go tree + debs from Dockerfile.vendor.
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_etcd
COPY vendored/etcd-src/ /src/
WORKDIR /src/server
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161389
RUN go build -trimpath -ldflags='-s -w -X=go.etcd.io/etcd/api/v3/version.GitSHA=2e8a5c9' -o /etcd . && /etcd --version && \
    { readelf -lW /etcd | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /etcd | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /etcd.needs
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_etcdctl
COPY vendored/etcd-src/ /src/
WORKDIR /src/etcdctl
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161389
RUN go build -trimpath -ldflags='-s -w -X=go.etcd.io/etcd/api/v3/version.GitSHA=2e8a5c9' -o /etcdctl . && /etcdctl version && \
    { readelf -lW /etcdctl | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /etcdctl | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /etcdctl.needs
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_etcdutl
COPY vendored/etcd-src/ /src/
WORKDIR /src/etcdutl
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161389
RUN go build -trimpath -ldflags='-s -w -X=go.etcd.io/etcd/api/v3/version.GitSHA=2e8a5c9' -o /etcdutl . && /etcdutl version && \
    { readelf -lW /etcdutl | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /etcdutl | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /etcdutl.needs
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795161389
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rootfs
ARG SOURCE_DATE_EPOCH=1795161389
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'etcd:x:999:999::/var/lib/etcd:/bin/sh\n' >> /rootfs/etc/passwd && printf 'etcd:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/var/lib/etcd /rootfs/data && chown -R 999:999 /rootfs/var/lib/etcd /rootfs/data
COPY --from=build_etcd /etcd /rootfs/usr/bin/etcd
COPY --from=build_etcd /etcd.needs /tmp/needs/etcd
COPY --from=build_etcdctl /etcdctl /rootfs/usr/bin/etcdctl
COPY --from=build_etcdctl /etcdctl.needs /tmp/needs/etcdctl
COPY --from=build_etcdutl /etcdutl /rootfs/usr/bin/etcdutl
COPY --from=build_etcdutl /etcdutl.needs /tmp/needs/etcdutl
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY readystack-entrypoint.sh /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN chmod 755 /rootfs/usr/bin/etcd /rootfs/usr/bin/etcdctl /rootfs/usr/bin/etcdutl /rootfs/usr/local/bin/rs-probe && \
    chown 999:999 /rootfs/usr/local/bin/readystack-entrypoint.sh && \
    chmod 0755 /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1795161389
COPY --from=rootfs /rootfs/ /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LABEL org.opencontainers.image.title="etcd"
LABEL org.opencontainers.image.version="v3.7.4-CE-ubuntu24.04-r1"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/etcd-io/etcd"
LABEL org.opencontainers.image.vendor="ReadyStack.dev"
LABEL readystack.product="etcd"
LABEL readystack.edition="CE"
LABEL readystack.build_method="source-rebuild-go"
LABEL org.opencontainers.image.revision="2e8a5c99e4982c8d4c521be15364ea4c5c68a489"
HEALTHCHECK --interval=5s --timeout=30s --start-period=10s \
  CMD /usr/local/bin/rs-probe http://127.0.0.1:2379/health || exit 1
USER etcd
EXPOSE 2379
ENTRYPOINT ["/usr/local/bin/readystack-entrypoint.sh"]
