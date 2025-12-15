#!/bin/bash
set -e

echo "🚀 Railway Dynamic Script Starting..."

# Validate env
if [ -z "$REPO_URL" ]; then
  echo "❌ REPO_URL is not set"
  exit 1
fi

if [ -z "$START_CMD" ]; then
  echo "❌ START_CMD is not set"
  exit 1
fi

if [ -n "$APT_PACKAGES" ]; then
  echo "📦 Installing extra apt packages: $APT_PACKAGES"
  apt-get update && apt-get install -y $APT_PACKAGES
fi

# Clone repo
echo "📥 Cloning repository..."
git clone --depth=1 "$REPO_URL" app
cd app

# Python deps
if [ -f requirements.txt ]; then
  echo "📦 Installing Python dependencies..."
  pip install --no-cache-dir -r requirements.txt
fi

# Node deps
if [ -f package.json ]; then
  echo "📦 Installing Node dependencies..."
  npm install
fi

# Start command
echo "▶ Running: $START_CMD"
exec bash -c "$START_CMD"
