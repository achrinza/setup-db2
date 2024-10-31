# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

# v27.3.1-dind
FROM docker.io/library/docker@sha256:7ae4f4ed9ca65170b52d42bff92b6f5249f46d6a2adea790b295cbd11ed50001
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
