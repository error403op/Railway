

FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive

# -------------------------
# System & build dependencies
# -------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    git \
    curl \
    wget \
    ca-certificates \
    unzip \
    xz-utils \
    redis-server \
    gnupg \
    \
    # Media & networking
    ffmpeg \
    \
    # Common runtime libs
    libglib2.0-0 \
    libgl1 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libgbm1 \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    libtiff-dev \
    libwebp-dev \
    libasound2 \
    \
    # Database drivers
    libpq-dev \
    chromium \
    chromium-driver \
    default-libmysqlclient-dev \
    \
    && rm -rf /var/lib/apt/lists/*


  
# -------------------------
# Node.js 20 LTS
# -------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# -------------------------

ENV BUN_INSTALL=/usr/local/bun
RUN mkdir -p $BUN_INSTALL && \
    curl -fsSL https://bun.sh/install | bash
ENV PATH=$BUN_INSTALL/bin:$PATH


# Playwright + Chromium
# -------------------------

ENV PLAYWRIGHT_BROWSERS_PATH=0

RUN npm install -g playwright

ENV OPENSSL_CONF=/etc/ssl



RUN playwright install chromium


# Python Playwright
ENV PLAYWRIGHT_BROWSERS_PATH=0
RUN pip install playwright
RUN python -m playwright install chromium
# -------------------------

# Set Chrome/Chromium environment variables
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# -------------------------
# PhantomJS
# -------------------------
RUN wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar -xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs \
    && rm -rf phantomjs-2.1.1-linux-x86_64*

# -------------------------
# Deno
# -------------------------
RUN curl -fsSL https://deno.land/install.sh | sh \
    && mv /root/.deno/bin/deno /usr/local/bin/deno

# -------------------------
# Python tooling
# -------------------------
RUN pip install --upgrade pip setuptools wheel

# Workdir & entry
# -------------------------
WORKDIR /app

EXPOSE 6379

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
