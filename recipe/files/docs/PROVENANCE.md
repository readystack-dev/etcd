# Provenance — etcd (`v3.7.4-CE-ubuntu24.04-r1`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/etcd-io/etcd
- Revision built: `v3.7.4` (commit `2e8a5c99e4982c8d4c521be15364ea4c5c68a489`)
- Source tree: `08927e30dd0dc2f13d504275b8d9518282e06ab819d10ee5d05709eaec71b240` over 1495 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-go`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795161389` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/etcd:v3.7.4-CE-ubuntu24.04-r1` — index digest `sha256:aad0529f02ff46af74193266f0fe827fb62d8527e6fbe9a6fe02be14894640f0` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:0a3fd6184f812c32e3754a5f897438311f23e0aa8eee61ccfe45e51f894e5149` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/etcd:v3.7.4-CE-ubuntu24.04-r1`

## Pinned inputs, and why

- 32 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 3, image digests 2, dependency versions readystack sets 7, pins in the kit's dockerfiles 11, readystack's build engine 5, dependencies upstream chose 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.trail.json`, published beside this archive and signed with the release key (`ReadyStack-etcd-v3.7.4-CE-ubuntu24.04-r1.trail.json.sigstore`), and readable at https://readystack.dev/products/etcd/trail/v3.7.4-CE-ubuntu24.04-r1.

