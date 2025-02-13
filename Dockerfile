# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:27.5.1-dind@sha256:de91b21638c6898b6ff2b52ce5f31031c08234dc6f718b8e16cdc045bfdc0d7f
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
