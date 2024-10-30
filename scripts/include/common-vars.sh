# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

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
