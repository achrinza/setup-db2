# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:7ae4f4ed9ca65170b52d42bff92b6f5249f46d6a2adea790b295cbd11ed50001 # v27.3.1-dind
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
