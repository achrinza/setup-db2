# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.0.1-dind@sha256:ecac43e78380d9b9d3bd24f0ab42b370f6391a1a06a66065c10a00b9d6d57a3e
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
