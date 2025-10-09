# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.5.1-dind@sha256:24173119fa6d1b5b4a27ab164fa7863deb66574ee5b90fef3b85dc888ef1a7e6
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
