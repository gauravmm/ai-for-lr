FROM node:24.18.0-bookworm-slim AS node
FROM ghcr.io/astral-sh/uv:0.12.6 AS uv
FROM python:3.12.13-slim-bookworm
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=uv /uv /uvx /usr/local/bin/
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && apt-get update && apt-get install -y --no-install-recommends \
       ca-certificates curl git openssh-client sudo procps less \
       libreoffice-impress fonts-open-sans fonts-liberation fontconfig \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 1000 --create-home --shell /bin/bash vscode \
    && printf 'vscode ALL=(root) NOPASSWD:ALL\n' > /etc/sudoers.d/vscode
COPY .devcontainer/claude-package*.json /opt/claude/
RUN cd /opt/claude && mv claude-package.json package.json && mv claude-package-lock.json package-lock.json \
    && npm ci --omit=dev && npm cache clean --force
COPY .course/course.py /opt/course/course.py
COPY .devcontainer/course /usr/local/bin/course
COPY .devcontainer/claude /usr/local/bin/claude
RUN chmod 755 /usr/local/bin/course /usr/local/bin/claude \
    && node --version && python --version && uv --version \
    && /opt/claude/node_modules/.bin/claude --version && libreoffice --version \
    && fc-match 'Open Sans'
ENV DISABLE_AUTOUPDATER=1
USER vscode
WORKDIR /workspaces/task
