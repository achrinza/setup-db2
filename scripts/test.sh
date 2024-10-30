#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

set -xe -o pipefail
trap 'cleanup_db2' INT HUP TERM

source "$(dirname "$0")/include/common-vars.sh"

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
  if [ "$HAS_DOCKER" ]; then
    "$STARTDB2" -l "$DB2_LICENSE"
  elif [ "$HAS_PODMAN" ]; then 
	  if [ "$IS_ROOT" ]; then
	    "$STARTDB2" -l "$DB2_LICENSE" -c podman
	  else
	    sudo su -c "'$STARTDB2' -l '$DB2_LICENSE' -c podman"
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
