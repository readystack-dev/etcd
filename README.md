[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Fetcd-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/etcd) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/etcd)](https://hub.docker.com/r/readystack/etcd) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/etcd) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# etcd: ReadyStack build kit

The offline build kit for the Docker image `readystack/etcd:v3.7.4-CE-ubuntu24.04-r1`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v3.7.4-CE-ubuntu24.04-r1](https://github.com/readystack-dev/etcd/releases/tag/v3.7.4-CE-ubuntu24.04-r1)
- Image: [`docker.io/readystack/etcd:v3.7.4-CE-ubuntu24.04-r1`](https://hub.docker.com/r/readystack/etcd/tags), manifest digest `sha256:0a3fd6184f812c32e3754a5f897438311f23e0aa8eee61ccfe45e51f894e5149`
- Product page: https://readystack.dev/products/etcd
- Source and build recipe: https://readystack.dev/products/etcd/recipe
- Build trail: https://readystack.dev/products/etcd/trail/v3.7.4-CE-ubuntu24.04-r1
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=etcd

## The image

A single container running a single-member etcd cluster as the non-root etcd user (uid 999). etcd is its own datastore: an embedded bbolt key-value store under /data (the --data-dir), so there is no separate database, sidecar or web UI. The image contains three static Go binaries: etcd (the server), etcdctl (the client) and etcdutl (offline data tools).

## Who uses etcd and why

Platform engineers who run Kubernetes control planes, and developers of distributed systems that need consistent shared state.

etcd is a distributed, reliable key-value store for a distributed system's most critical data. It replicates writes across its members with the Raft consensus algorithm, so the data stays consistent when a member fails.

A typical use: A Kubernetes control plane keeps all of its API data in etcd. Running etcd as a cluster of members on separate machines means the cluster's state survives the loss of one machine, and the remaining members keep serving reads and writes.

From the upstream project's own description: https://github.com/etcd-io/etcd, https://kubernetes.io/docs/concepts/overview/components/.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-20 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 7 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`etcd`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-20; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/etcd.

etcd is distributed under its upstream licence (Apache-2.0); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v3.7.4-CE-ubuntu24.04-r1 release](https://github.com/readystack-dev/etcd/releases/tag/v3.7.4-CE-ubuntu24.04-r1): `ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.tar.gz` (455.2 MB), SHA-256 `66dacc2bd8e81abc670b206775e63dd997307a454f236e576c07d854281dbe8f`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.rebuild.json.sigstore ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.tar.gz
cd v3.7.4-CE-ubuntu24.04-r1
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/etcd/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
