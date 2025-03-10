#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

set -eu
trap 'cleanup_db2 1' INT HUP TERM

MODE=run
DB2_VERSION='latest'
DB2_INSTANCE=db2inst1
DB2_PASSWORD=password
DB2_DBNAME=mydb
DB2_DATABASE_DIR=/tmp/db2-database
DB2_CONTAINER_NAME=db2server
DB2_LICENSE=decline
DOCKER_CLI=docker
TIMEOUT=300

show_help () {
   cat <<EOF
$0 [-h] [-C] [-t db2_version] [-i db2_instance] [-p db2_password] [-d db2_dbname] [-D db2_database_directory] [-n db2_container_name] [-c docker_cli]

    -h    Show help
    -C    Run cleanup script only
    -V    DB2 version
              Default: $DB2_VERSION
              An OCI image tag or digest
    -i    DB2 instance name
              Default: $DB2_INSTANCE
              The instnace name will also be the username used to login to the DB2 instance.
    -p    DB2 password
              Default: $DB2_PASSWORD
    -d    DB2 dbname
              Default: $DB2_DBNAME
    -D    DB2 database directory mountpoint on host machine.
              Default: $DB2_DATABASE_DIR
    -n    DB2 container name
              Default: $DB2_CONTAINER_NAME
    -l    DB2 license
              Must be explicitly set to "accept" to accept the DB2 license agreement.
              Default: $DB2_LICENSE
    -t    Timeout
              Duration to wait for the DB2 container to be ready before aborting.
              Default: $TIMEOUT
    -c    Docker-compatible CLI
              Default: $DOCKER_CLI
              The program to use for running Docker-compatible commands.

EOF
}

parse_opts () {
  OPTIND=1
  while getopts ':hCV:i:p:d:D:n:l:t:c:' opt; do
    case "$opt" in
      \?)
        echo "Invalid option: -$OPTARG" 1>&2
        show_help
        exit 2
        ;;
      h)
        show_help
        exit 0
        ;;
      C)
        MODE=clean
        ;;
      V)
        echo "$OPTARG"
        DB2_VERSION="$OPTARG"
        ;;
      i)
        DB2_INSTANCE="$OPTARG"
        ;;
      p)
        DB2_PASSWORD="$OPTARG"
        ;;
      d)
        DB2_DBNAME="$OPTARG"
        ;;
      D)
        DB2_DATABASE_DIR="$OPTARG"
        ;;
      n)
        DB2_CONTAINER_NAME="$OPTARG"
        ;;
      l)
        DB2_LICENSE="$OPTARG"
        ;;
      t)
        TIMEOUT="$OPTARG"
        ;;
      c)
        DOCKER_CLI="$OPTARG"
        ;;
    esac
  done
  DB2_USERNAME="$(echo "$DB2_INSTANCE" | tr '[:upper:]' '[:lower:]')"
}

start_db2 () {
  echo 'Starting DB2...'
  echo 'Note: This script will attempt to clean up when terminated.'
  case "$DB2_VERSION" in
    :*|@*)
      DB2_VERSION_RESOLVED="$DB2_VERSION"
      ;;
    sha256*)
      DB2_VERSION_RESOLVED="@$DB2_VERSION"
      ;;
    *)
      DB2_VERSION_RESOLVED=":$DB2_VERSION"
      ;;
  esac
  if [ ! -e "$DB2_DATABASE_DIR" ]; then
    mkdir "$DB2_DATABASE_DIR"
  else
    cat <<EOF 1>&2
Directory "$DB2_DATABASE_DIR" already exists. Please either:

1. Delete the directory, or
2. Use a different directory with the "-D" option, or
3. Run a cleanup with "$0 -C$([ "$DOCKER_CLI" = 'podman' ] && printf 'c podman' )"
EOF
      exit 2
  fi
  if ! \
    "$DOCKER_CLI" run \
      --detach \
      --privileged \
      --name="$DB2_CONTAINER_NAME" \
      --publish='50000:50000' \
      --volume="$DB2_DATABASE_DIR:/database" \
      --env="DB2INSTANCE=$DB2_INSTANCE" \
      --env="DB2INST1_PASSWORD=$DB2_PASSWORD" \
      --env="DBNAME=$DB2_DBNAME" \
      --env="LICENSE=$DB2_LICENSE" \
      "icr.io/db2_community/db2$DB2_VERSION_RESOLVED" 1>/dev/null; then
    echo "code $?"
    echo "Error starting DB2 container." 1>&2
    cleanup_db2 1
    exit 2
  fi
}

wait_for_db2 () {
  FEEDBACK="${1:-initialize}"
  DELAY="${2:-0}"
  TIMER=0
  printf "Waiting for DB2 to %s (Timeout: 5 mins)." "$FEEDBACK"

  until [ "$TIMER" -eq "$DELAY" ]; do
    printf '.'
    sleep 1
    TIMER="$((TIMER + 1))"
  done
  
  until \
    cat <<EOF | "$DOCKER_CLI" exec -iu "$DB2_USERNAME" "$DB2_CONTAINER_NAME" bash 1>/dev/null 2>/dev/null
        source ~/.bashrc
        db2 CONNECT TO $DB2_DBNAME
        db2 SELECT \* FROM sysibm.sysdummy1
EOF
  do
    printf '.'
    sleep 1
    TIMER="$((TIMER + 1))"
    if [ "$TIMER" -eq "$TIMEOUT" ]; then
      echo
      echo "DB2 did not $FEEDBACK within $((TIMEOUT / 60)) minutes. Exiting." 1>&2
      cleanup_db2 2
    fi
  done
  echo
  echo "DB2 $FEEDBACK complete!"
}

wait_for_db2_initialize() {
  wait_for_db2
}

wait_for_db2_restart() {
  wait_for_db2 'restart' 5
  echo "DB2 ready!"
}

cleanup_db2 () {
    echo 'Cleaning up DB2 files...'
    echo "Stopping and deleting container \"$DB2_CONTAINER_NAME\"..."
    # shellcheck disable=2091
    if $(
      "$DOCKER_CLI" stop "$DB2_CONTAINER_NAME" 1>/dev/null
      "$DOCKER_CLI" rm "$DB2_CONTAINER_NAME" 1>/dev/null
    ); then
      echo 'Done!'
    else
      echo 'Done (with errors)!'
    fi
      echo "Deleting \"$DB2_DATABASE_DIR\" directory if it exists (will use sudo if available)..."
    if [ -e "$DB2_DATABASE_DIR" ]; then
      if [ "$(command -v sudo)" ]; then
        sudo rm -r "$DB2_DATABASE_DIR"
      else
        rm -r "$DB2_DATABASE_DIR"
      fi
      echo 'Done!'
    else
      echo 'Directory does not exist. Skipping.'
    fi

    if [ "$1" ]; then
      exit "$1"
    fi
}

# shellcheck disable=SC2068
parse_opts $@
if [ "$MODE" = 'clean' ]; then
  cleanup_db2 0
else
  start_db2
  wait_for_db2_initialize
  wait_for_db2_restart
fi
