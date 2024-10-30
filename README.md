<!--
  SPDX-License-Identifier: FSFAP
  SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza
-->

# Quick Dev Setup for DB2 LUW

Unofficial utility to setup a **development** DB2 LUW server quickly and easily on plain Linux or Github Actions

> !!note
> This is still in early development. Please pin to a Git hash if you need to use it

## Usage (`start-db2.sh`)

Ensure that:

1. You agree to the license agreement that comes with the DB2 OCI image
2. SELinux is disabled (sorry)
3. Docker or Podman is installed
4. If you're using Podman, you're running the script as root

To start up DB2 LUW:

```sh
# If you're using Docker:
$ ./start-db2.sh -l accept

# If you're using Podman (must run as root):
$ sudo su -c './start-db2.sh -l accept -c podman'

Starting DB2...
Note: This script will attempt to clean up when terminated.
Waiting for DB2 to initialize (Timeout: 5 mins)..............................................................................
DB2 initialize complete!
Waiting for DB2 to restart (Timeout: 5 mins)..........
DB2 restart complete!
DB2 ready!
```

Run `./start-db2.sh -h` for a full list of options.

## Usage (GitHub Actions)

Minimal setup with a Node.js application:

```yaml
on: [push, pull]
jobs:
  test-ghaction:
    name: Test
    runs-on: ubuntu-24.04
      - name: Start DB2 Server
        uses: achrinza/setup-db2@main
        with:
          db2-version: latest
      - name: Checkout
        uses: actions/checkout@v4
        with:
          depth: 1
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
      - name: Bootstrap Dependencies
        run: npm ci
      - name: Run Tests
        run: npm test
```

or take inspiration from this repo's own [`ci.yaml`](./.github/workflows/ci.yaml) workflow.

## Features & Limitations (`start-db2.sh`)

1. Does not work with SELinux enforcement enabled
2. Podman must run as root
3. No Windows script (macOS untested)

## Limitations (GitHub Actions)

#TODO

## License

This repository uses multiple licenses. The general guideline is as follows:

| Document type | License                       |
| ------------- | ----------------------------- |
| Source code   | [MIT](./LICENSES/MIT.txt)     |
| Configuration | [FSFAP](./LICENSES/FSFAP.txt) |
| Documentation | [FSFAP](./LICENSES/FSFAP.txt) |

This repository complies with [REUSE](https://reuse.software). Consult the respective file's header or `*.license` file for more information.
