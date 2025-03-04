# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.0.1-dind@sha256:9a651b22672c7151b5d8ca820ed2290b3fe4d4922e9b3f37ab14c8876da6613d
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
