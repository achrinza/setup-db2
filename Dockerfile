# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.9.2-dind@sha256:ba3d67c44952ffc448696659a36ef91dd813f03a9c70a2bc0ad1d286d542f4fb
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
