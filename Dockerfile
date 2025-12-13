# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:29.1.3-dind@sha256:7370a6c49b7e708fb969b422dffe6cdd78a9f0ff5b3bfba0e0cddce736c49eaf
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
