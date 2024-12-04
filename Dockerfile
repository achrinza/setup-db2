# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:27.3.1-dind@sha256:6ca9a6811085e2cf769cbac04bc47daf66629102990391caab7cf37426e939da
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
