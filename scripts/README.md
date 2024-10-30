<!--
  SPDX-License-Identifier: FSFAP
  SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza
-->

# Internal Scripts

`test.sh` is an **internal** wrapper script around `start-db2.sh`. It is opinionated and does the following in order:

1. Auto-detects Docker and Podman CLI in that order
2. Performs pre-test opportunistic cleanup
3. Bootstraps dependencies
4. Elevates Podman to root (needed as DB2 remounts volumes)
5. Runs the Node.js test suite
6. Cleans up after itself

## Usage

Simply call this script with no options (`./scripts/test.sh`) and the test suite will execute.

## Wishlist

Wishlist of things to add to this script:

1. Auto-detect SELinux
   a. Temporarily install necessary policy to make the container work
2. Support a Flatpak split environment
   a. Temporarily install missing shared libraries (`.so`)
   b. Run tests in two stages (DB2 contaner on host machine, test suite in Flatpak)
3. Provide a helpful error message if Podman/Docker or Node.js is not installed
4. Perform E2E testing of GitHub Action using `act`
