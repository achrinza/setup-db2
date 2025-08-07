# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza

FROM docker.io/library/docker:28.3.3-dind@sha256:c0872aae4791ff427e6eda52769afa04f17b5cf756f8267e0d52774c99d5c9de
COPY start-db2.sh /start-db2.sh
RUN chmod +x /start-db2.sh
ENTRYPOINT ["/start-db2.sh"]
