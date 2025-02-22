# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.0.0-dind@sha256:0a9c58ebc9f86e5af35e4330f6c738dc64fce3ca2e2574b5becdfb88765b308b
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
