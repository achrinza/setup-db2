# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.0.4-dind@sha256:c9699f4fc7365e8daad3eb48ce3b62dc118b2a5267f7be7bcd3c4e4b2f1cfb4c
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
