# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.4.0-dind@sha256:831644212c5bdd0b3362b5855c87b980ea39a83c9e9adcef2ce03eced99a737a
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
