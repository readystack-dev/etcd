#!/bin/sh
# ReadyStack etcd entrypoint: a single-member cluster with authentication on from its first start.
# First start (no /data/member yet) needs ETCD_ROOT_PASSWORD: the member is created and the root user and
# authentication are set up while etcd listens on loopback only, so the client port is never open without
# authentication. ALLOW_NONE_AUTHENTICATION=yes starts without authentication instead. Later starts use the
# existing data and ignore both. Arguments after the image name are passed to etcd.
set -e
set -- --name s1 --data-dir /data \
  --advertise-client-urls http://127.0.0.1:2379 \
  --listen-peer-urls http://127.0.0.1:2380 --initial-advertise-peer-urls http://127.0.0.1:2380 \
  --initial-cluster s1=http://127.0.0.1:2380 --initial-cluster-state new --initial-cluster-token rs-etcd "$@"
# etcd reads ETCD_* variables as its own flags and logs unknown ones with their values: never pass it on.
PW="${ETCD_ROOT_PASSWORD:-}"
unset ETCD_ROOT_PASSWORD
if [ ! -d /data/member ]; then
  if [ -n "$PW" ]; then
    etcd "$@" --listen-client-urls http://127.0.0.1:2379 >/tmp/etcd-first-start.log 2>&1 &
    pid=$!
    n=0
    until etcdctl --endpoints=http://127.0.0.1:2379 endpoint health >/dev/null 2>&1; do
      n=$((n + 1))
      if [ "$n" -gt 60 ] || ! kill -0 "$pid" 2>/dev/null; then
        echo "etcd: first start failed; etcd output follows" >&2
        cat /tmp/etcd-first-start.log >&2
        kill "$pid" 2>/dev/null || true
        exit 1
      fi
      sleep 1
    done
    etcdctl --endpoints=http://127.0.0.1:2379 user add root --new-user-password="$PW" >/dev/null
    etcdctl --endpoints=http://127.0.0.1:2379 auth enable >/dev/null
    kill "$pid"
    wait "$pid" || true
    echo "etcd: first start: created user root with the password from ETCD_ROOT_PASSWORD and enabled authentication"
  elif [ "${ALLOW_NONE_AUTHENTICATION:-no}" = "yes" ]; then
    echo "etcd: ALLOW_NONE_AUTHENTICATION=yes: starting WITHOUT authentication; anyone who can reach port 2379 can read and change every key" >&2
  else
    echo "etcd: the first start needs ETCD_ROOT_PASSWORD (it becomes the password of the root user and turns on authentication), or ALLOW_NONE_AUTHENTICATION=yes to run without authentication" >&2
    exit 1
  fi
fi
unset PW
exec etcd --listen-client-urls http://0.0.0.0:2379 "$@"
