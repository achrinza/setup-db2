# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.9.3-dind@sha256:d035bd30886e451b2727ef3cdb9af9a5c537a10d4bc5d18c08d0ffa597e46aeb
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
