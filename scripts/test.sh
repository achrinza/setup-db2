#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza
set -eu
trap 'cleanup_db2' INT HUP TERM

STARTDB2="$(dirname "$0")/../start-db2.sh"
DB2_LICENSE="${DB2_LICENSE:-'decline'}"
if [ "$(command -v docker)" != '' ]; then
  HAS_DOCKER=1
fi
if [ "$(command -v podman)" != '' ]; then
  HAS_PODMAN=1
fi
if [ "$(whoami)" = 'root' ]; then
  IS_ROOT=1
fi

cleanup_db2 () {
  if [ "$HAS_DOCKER" ]; then
	  ./start-db2.sh -C
  elif [ "$HAS_PODMAN" ]; then
	  if [ "$IS_ROOT" ]; then
	    "$STARTDB2" -Cc podman
	  else
	    sudo su -c "$STARTDB2 -Cc podman"
	  fi
  fi
}

start_db2 () {
  if [ "$CI" ]; then
    ADD_OPTS='-t 600'
  fi
  if [ "$HAS_DOCKER" ]; then
    # shellcheck disable=2086
    "$STARTDB2" -l "$DB2_LICENSE" $ADD_OPTS
  elif [ "$HAS_PODMAN" ]; then 
	  if [ "$IS_ROOT" ]; then
      # shellcheck disable=2086
	    "$STARTDB2" -l "$DB2_LICENSE" -c podman $ADD_OPTS
	  else
      # shellcheck disable=2086
	    sudo su -c "'$STARTDB2' -l '$DB2_LICENSE' -c podman" $ADD_OPTS
	  fi
  fi
}

run_tests() {
  npm ci --prefer-offline
  npm test --ignore-scripts
}

cleanup_db2
start_db2
run_tests
cleanup_db2
