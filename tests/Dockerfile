# STAGE 1: Bau des Pakets
FROM ubuntu:24.04 AS builder
# Wir brauchen dpkg-dev für dpkg-deb und andere Build-Tools
RUN apt-get update && apt-get install -y dpkg devscripts bash curl gpg
WORKDIR /build

# 1. Alles kopieren
COPY . .

# 2. Das Paket bauen (Das erstellt den /build/dist Ordner)
# Stelle sicher, dass package.sh ausführbar ist oder mit bash aufgerufen wird
RUN mkdir -p dist && bash scripts/package.sh

# STAGE 2: Test der Installation
# STAGE 2: Test Environment
FROM ubuntu:24.04

# 1. Benötigte Tools für das lokale Repo
RUN apt-get update && apt-get install -y \
    sudo \
    ca-certificates \
    dpkg-dev \
    && rm -rf /var/lib/apt/lists/*


# 4. Das Repo bei APT anmelden
RUN echo "deb [trusted=yes] http://192.168.188.49/mema ./" > /etc/apt/sources.list.d/mema-remote.list
RUN apt-get update && apt-get install -y

# 6. User-Setup
RUN useradd -m -s /bin/bash tester && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER tester
WORKDIR /home/tester
RUN mkdir -p /home/tester/.local/share/mema/recipes && \
    chown -R tester:tester /home/tester && \
    chmod -R 755 /home/tester

CMD ["/bin/bash"]
# 7. Funktionstest
# RUN --mount=type=cache,target=/opt/mema/cache,uid=1000 \
#     sudo mema install go latest
