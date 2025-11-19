# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.0.2-dind@sha256:d003717ad7a27d359dd2f5f6aa6ca691f5f58671e8d1ff0277d07e5635bb8332
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
