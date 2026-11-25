# etcd v3.7.4 — ReadyStack release `v3.7.4-CE-ubuntu24.04-r1`

Generated 2026-11-20 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/etcd:v3.7.4-CE-ubuntu24.04-r1` (linux/amd64). Index digest `sha256:aad0529f02ff46af74193266f0fe827fb62d8527e6fbe9a6fe02be14894640f0` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:0a3fd6184f812c32e3754a5f897438311f23e0aa8eee61ccfe45e51f894e5149` [`TARGET_DIGEST.txt`].
- **Upstream:** etcd v3.7.4 built from source at `v3.7.4` of https://github.com/etcd-io/etcd — upstream notes: https://github.com/etcd-io/etcd/releases/tag/v3.7.4 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `etcd`.
- **Build:** `source-rebuild-go`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `v3.7.3-CE-ubuntu24.04-r3`.

## What changed in this release

- Upstream version v3.7.3 → v3.7.4.
- Minimum dependency versions ReadyStack enforces on top of upstream (raised only where upstream's own version was lower); shipped versions from the SBOM [`docs/sbom/SBOM.json`]:
  - `golang.org/x/crypto` at least `v0.58.0`: not raised, upstream already pins `v0.58.0` (shipped: `v0.58.0`)
  - `golang.org/x/net` at least `v0.62.0`: not raised, upstream already pins `v0.62.0` (shipped: `v0.62.0`)
  - `go.opentelemetry.io/otel` at least `v1.43.0`: not raised, upstream already pins `v1.45.0` (shipped: `v1.45.0`)
  - `go.opentelemetry.io/otel/sdk` at least `v1.43.0`: not raised, upstream already pins `v1.45.0` (shipped: `v1.45.0`)
  - `google.golang.org/grpc` at least `v1.83.2`: not raised, upstream already pins `v1.83.2` (shipped: `v1.83.2`)
- This release moves etcd from 3.7.3 to 3.7.4, a newer release of upstream's 3.7.x line. Upstream's release notes list what changed: https://github.com/etcd-io/etcd/releases/tag/v3.7.4

## Security status at release (measured 2026-11-20)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `etcd` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/etcd:v3.7.4-CE-ubuntu24.04-r1` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Client traffic on port 2379 is plain HTTP without TLS: passwords and data cross the network in clear text. Keep the port on a private network, or configure TLS with --cert-file/--key-file and https:// URLs.
- **Before exposing this service:** /metrics on port 2379 answers without credentials, and --listen-metrics-urls does not change that (it adds a second address that also serves /metrics); /livez, /readyz, /debug/vars (etcd's full command line, raft status and memory statistics) and `etcdctl auth status` need no credentials either. Keep port 2379 on a private network if that matters to you.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:0a3fd6184f812c32e3754a5f897438311f23e0aa8eee61ccfe45e51f894e5149`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 3 of 3 use cases passed (3 authored) against the running image [`docs/validation/test-results.json`].
- The cases are `GET /health` (200), `GET /version` (200), `GET /metrics` (200); the suite checks nothing else.

## Known issues

- **medium** (upstream): etcd serves /metrics on the client port without authentication, and --listen-metrics-urls does not move it off that port (https://github.com/etcd-io/etcd/issues/20580) [`RSD-etcd-b2925e10ee`] (carried from `v3.7.2-CE-ubuntu24.04-r1`, recorded there as `RSD-etcd-a36504ed8d`)
- **low** (ReadyStack package): Docker Hub README: Generic sentence tells the customer to take first-start passwords out of the env file; ETCD_ROOT_PASSWORD is such a password, and the same README says to keep it because the documented docker exec… [`RSD-etcd-10f1d23823`]

## Defects fixed

- 7 problems found before release and fixed before it shipped (7 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/etcd:v3.7.4-CE-ubuntu24.04-r1
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

