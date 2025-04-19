# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.1.1-dind@sha256:f49e1c71b5d9f8ebe53715f78996ce42b8be4b1ec03875d187dfe3c03de1dc00
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
