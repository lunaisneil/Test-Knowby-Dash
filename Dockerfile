# Use Node.js base image with Debian (for Python compatibility)
FROM node:20-slim

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3.11-venv \
    libglib2.0-0 \
    libnspr4 \
    libnss3 \
    libdbus-1-3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libcairo2 \
    libpango-1.0-0 \
    libasound2
    
# Install Playwright browsers
RUN npm install -g playwright && npx playwright install chromium

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Install Node.js dependencies
RUN npm install

# Install Python dependencies
RUN python3 -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install -r python-scripts/requirements.txt
ENV PATH="/venv/bin:$PATH"

# Expose port (change if your app uses a different port)
EXPOSE 8080

# Start your app (customize as needed)
RUN npm run build
CMD ["npm", "start"]