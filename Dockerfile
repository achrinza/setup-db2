# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.1.3-dind@sha256:173f284a4299164772a90f52b373e73e087583c0963f1334c9995f190ef6f3f5
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
