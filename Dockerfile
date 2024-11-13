# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:27.3.1-dind@sha256:bec82cb05983f12a14d8f169b00748f4ded8573f4da5f1d15d375b6a2470289f
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
