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

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/etcd/recipe. The complete kit is the release download. Each release is a tag here.

— ReadyStack · https://readystack.dev
