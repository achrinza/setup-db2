<!--
  SPDX-License-Identifier: FSFAP
  SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza
-->

# Dev Setup for DB2 LUW

Unofficial utility to setup a **development** DB2 LUW server quickly and easily on plain Linux or Github Actions

> [!NOTE]
> This is still in early development.

## Badges

| Badge                                                                                                                                                           | Description  | Service              |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | -------------------- |
| [![Code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square")](https://github.com/prettier/prettier#readme)          | Code style   | Prettier             |
| [![Conventional Commits: 1.0.0](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=flat-square)](https://conventionalcommits.org/)      | Commit style | Conventional Commits |
| [![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg?style=flat-square)](https://renovatebot.com/)                                | Dependencies | Renovate             |
| [![CI](https://github.com/achrinza/setup-db2/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/achrinza/setup-db2/actions/workflows/ci.yaml) | CI pipeline  | GitHub Actions       |

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

## Usage (Github Action)

Minimal setup with a Node.js application:

```yaml
on: [push, pull]
jobs:
  test-ghaction:
    name: Test
    runs-on: ubuntu-latest
      - name: Start DB2 Server
        uses: achrinza/setup-db2@v0
        with:
          db2-license: accept
          db2-version: latest
      - name: Checkout
        uses: actions/checkout@v4
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

## Limitations (`start-db2.sh`)

1. Does not work with SELinux enforcement enabled
2. Podman must run as root
3. Does not work as-is on GitHub-hosted runners
4. No Windows script (macOS untested)
5. Does not support configuring certain DB2 features:
   a. No BLU support
   b. No HADR support
   c. No clustering support

## Limitations (GitHub Actions)

1. All limitations of `start-db2.sh` (except 1-3)
2. No support to spin up multiple intances
3. No OCI image caching

## License

This repository uses multiple licenses. The general guideline is as follows:

| Document type | License                       |
| ------------- | ----------------------------- |
| Source code   | [MIT](./LICENSES/MIT.txt)     |
| Configuration | [FSFAP](./LICENSES/FSFAP.txt) |
| Documentation | [FSFAP](./LICENSES/FSFAP.txt) |

This repository complies with [REUSE](https://reuse.software). Consult the respective file's header or `*.license` file for more information.
