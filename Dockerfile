# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:27.5.1-dind@sha256:3ab005a2e4872f0b10fb9c00d4230334043f1281f29299bd3de94a8f14a05e69
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
