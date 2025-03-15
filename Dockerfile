# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.0.1-dind@sha256:ddf7f6fd0d2175709739f1d47e6134fa8eb055d2f61c11c3f99780c79b44578e
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
