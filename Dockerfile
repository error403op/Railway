FROM python:3.12-slim

# System deps
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ffmpeg \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

WORKDIR /app

# Copy start script only
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
