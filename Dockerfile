# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.7.0-dind@sha256:084e385b0c9b7ab35d5a46dfedd033721448c000dbec71adcf13da8a9e71baa8
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
