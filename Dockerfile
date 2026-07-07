FROM ubuntu:24.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG USERNAME=dev
ARG USER_UID=99
ARG USER_GID=100
ARG IDENTITY=temp
ARG INSTALL_VIM_PLUGINS=0
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY
ARG http_proxy
ARG https_proxy
ARG no_proxy

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    DEV_USER=${USERNAME} \
    DEV_HOME=/home/${USERNAME} \
    DEV_GID=${USER_GID} \
    IDENTITY=${IDENTITY} \
    INSTALL_VIM_PLUGINS=${INSTALL_VIM_PLUGINS}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        locales \
        software-properties-common \
        sudo \
        tzdata \
    && add-apt-repository -y universe \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/dotfiles

RUN chmod +x /opt/dotfiles/docker/entrypoint.sh

RUN bash /opt/dotfiles/docker/install-ubuntu-packages.sh

RUN if getent group "${USER_GID}" >/dev/null; then \
        GROUP_NAME="$(getent group "${USER_GID}" | cut -d: -f1)"; \
    else \
        GROUP_NAME="${USERNAME}"; \
        groupadd --gid "${USER_GID}" "${GROUP_NAME}"; \
    fi \
    && useradd --non-unique --uid "${USER_UID}" --gid "${USER_GID}" --create-home --shell /usr/bin/zsh "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && chown -R "${USERNAME}:${USER_GID}" "/home/${USERNAME}" /opt/dotfiles \
    && sudo -H -u "${USERNAME}" env \
        IDENTITY="${IDENTITY}" \
        INSTALL_VIM_PLUGINS="${INSTALL_VIM_PLUGINS}" \
        HTTP_PROXY="${HTTP_PROXY:-${http_proxy:-}}" \
        HTTPS_PROXY="${HTTPS_PROXY:-${https_proxy:-}}" \
        NO_PROXY="${NO_PROXY:-${no_proxy:-}}" \
        http_proxy="${http_proxy:-${HTTP_PROXY:-}}" \
        https_proxy="${https_proxy:-${HTTPS_PROXY:-}}" \
        no_proxy="${no_proxy:-${NO_PROXY:-}}" \
        bash /opt/dotfiles/docker/install-dotfiles.sh "/home/${USERNAME}" "${USERNAME}"

ENTRYPOINT ["/opt/dotfiles/docker/entrypoint.sh"]
WORKDIR /home/${USERNAME}

CMD ["/usr/bin/zsh", "-l"]
