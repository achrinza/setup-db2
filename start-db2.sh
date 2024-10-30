#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

set -e -o pipefail
trap 'cleanup_db2 1' INT HUP TERM

MODE=run
DB2_VERSION=latest
DB2_INSTANCE=db2inst1
DB2_PASSWORD=password
DB2_DBNAME=mydb
DB2_DATABASE_DIR=/tmp/db2-database
DB2_CONTAINER_NAME=db2server
DB2_LICENSE=
DOCKER_CLI=docker

show_help () {
   cat <<EOF
$0 [-h] [-C] [-t db2_version] [-i db2_instance] [-p db2_password] [-d db2_dbname] [-D db2_database_directory] [-n db2_container_name] [-c docker_cli]

    -h    Show help
    -C    Run cleanup script only
    -t    DB2 version (OCI image tag)
              Default: $DB2_VERSION
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
              Must be explicitly set to `accept` to accept the DB2 license agreement.
    -c    Docker-compatible CLI
              Default: $DOCKER_CLI
              The program to use for running Docker-compatible commands.

EOF
}

parse_opts () {
  OPTIND=1
  while getopts ':hCt:i:p:d:D:n:l:c:' opt; do
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
      t)
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
      c)
        DOCKER_CLI="$OPTARG"
        ;;
    esac
  done
  DB2_USERNAME="$(echo $DB2_INSTANCE | tr 'A-Z' 'a-z')"
}

start_db2 () {
  echo 'Starting DB2...'
  echo 'Note: This script will attempt to clean up when terminated.'
  if [ ! -e "$DB2_DATABASE_DIR" ]; then
    mkdir "$DB2_DATABASE_DIR"
  else
      echo "Directory \`$DB2_DATABASE_DIR\` already exists. Please delete this directory or set the \`-D\` flag." 1>&2
      exit 2
  fi
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
    "icr.io/db2_community/db2:$DB2_VERSION" 1>/dev/null
  if [ "$?" -ne 0 ]; then
    echo "Error starting DB2 container." 1>&2
    exit 2
  fi
}

wait_for_db2 () {
  FEEDBACK="${1:-initialize}"
  DELAY="${2:-0}"
  TIMEOUT=300
  TIMER=0
  printf "Waiting for DB2 to $FEEDBACK (Timeout: 5 mins)."

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
    echo "Stopping and deleting container \`$DB2_CONTAINER_NAME\`..."
    if [ "$(
      "$DOCKER_CLI" stop "$DB2_CONTAINER_NAME" 1>/dev/null
      "$DOCKER_CLI" rm "$DB2_CONTAINER_NAME" 1>/dev/null
    )" ]; then
      echo 'Done!'
    else
      echo 'Done (with errors)!'
    fi
      echo "Deleting \`$DB2_DATABASE_DIR\` directory if it exists (will use sudo if available)..."
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

parse_opts $@
if [ "$MODE" = 'clean' ]; then
  cleanup_db2 0
else
  start_db2
  wait_for_db2_initialize
  wait_for_db2_restart
fi
