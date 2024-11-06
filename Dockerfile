# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:27.3.1-dind@sha256:ccfd877fe10a2fe0cdb1f35c43aba2fed90007dbf7e0678b1951297c72296e8d
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
