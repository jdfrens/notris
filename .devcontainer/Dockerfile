FROM hexpm/elixir:1.10.2-erlang-22.3.2-alpine-3.12.0

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# [Optional] Install Node.js for use with web applications - update the INSTALL_NODE arg in devcontainer.json to enable.
# ARG INSTALL_NODE="true"
# ARG NODE_VERSION="14.1.0"
# ENV NVM_DIR=/usr/local/share/nvm \
#     NVM_SYMLINK_CURRENT=true \
#     PATH=${NVM_DIR}/current/bin:${PATH}
# RUN if [ "$INSTALL_NODE" = "true" ]; then \
#         /bin/bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
#         && apt-get clean -y && rm -rf /var/lib/apt/lists/*; \
#     fi \
#     && rm -rf /tmp/library-scripts
