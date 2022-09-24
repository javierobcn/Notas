FROM python:3.8.12-slim-bullseye

# makes bash show every command (for better docker build debugging) and prevents errors on a pipeline from being masked.
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

ARG UID
# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8


# Install some deps
COPY system-requirements.txt /system-requirements.txt

# Update & Install system packages
RUN apt-get update && \
    xargs apt-get install -y --no-install-recommends  < /system-requirements.txt \
    && rm -rf /var/lib/apt/lists/*

# Upgrade PIP
RUN pip install --upgrade pip


# Install Template Dependencies
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt


COPY .env /.env

USER root
WORKDIR /mnt

CMD ["mkdocs","serve","--dev-addr","0.0.0.0:8000"]
