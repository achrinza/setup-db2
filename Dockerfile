# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.1.5-dind@sha256:3a33fc81fa4d38360f490f5b900e9846f725db45bb1d9b1fe02d849bd42a5cf2
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
