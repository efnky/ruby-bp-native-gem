FROM ruby:3.3-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4

FROM ruby:3.3-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/* && \
    groupadd -r appuser && useradd -r -g appuser -u 1001 appuser
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app/.bundle /app/.bundle
COPY --from=builder /app/vendor/bundle /app/vendor/bundle
COPY . .
EXPOSE 3000
USER 1001
ENV PORT=3000
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "3000"]