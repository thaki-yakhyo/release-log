# syntax=docker/dockerfile:1

# Multi-stage build for smaller production images
FROM python:3.10-slim AS builder

# Set build arguments
ARG VERSION=dev

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy build files
COPY pyproject.toml VERSION ./
COPY src ./src

# Build wheel
RUN pip install --upgrade pip build && \
    python -m build -o dist && \
    pip wheel --no-deps dist/*.whl -w wheels

# Production stage
FROM python:3.10-slim AS runtime

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy wheels from builder stage
COPY --from=builder /app/wheels /wheels

# Install the package
RUN pip install --no-cache-dir /wheels/*.whl && \
    rm -rf /wheels

# Copy application files
COPY . .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import releaselog; print('OK')" || exit 1

# Default command
CMD ["release-log", "info"]

# Labels for metadata
LABEL org.opencontainers.image.title="release-log" \
      org.opencontainers.image.description="Simple Release Automation Testing Package" \
      org.opencontainers.image.vendor="thaki-yakhyo" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/thaki-yakhyo/release-log"
