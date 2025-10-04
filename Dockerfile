# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.5.0-dind@sha256:c090c93b63bc690570a0cab398904c855a46f08e0b6804e51bb5ad26e3407f9a
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
