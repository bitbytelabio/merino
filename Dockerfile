# syntax=docker/dockerfile:1
FROM rust:alpine AS builder
RUN apk add --no-cache build-base

LABEL org.opencontainers.image.description="This Docker image contains Merino SOCKS5 proxy server."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/bitbytelabio/merino"

# Don't download the entire crates.io package index. Fetch only the index
# entries for crates that are actually used. This is faster and avoids a memory
# usage explosion that often breaks docker builds.
# https://blog.rust-lang.org/inside-rust/2023/01/30/cargo-sparse-protocol.html#background
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse"

WORKDIR /app/
COPY Cargo.toml Cargo.lock ./
COPY src/ src/
RUN cargo build --release

FROM alpine:latest
RUN addgroup -S merino && \
    adduser -S -G merino merino && \
    apk add --no-cache tini
USER merino
COPY --from=builder /app/target/release/merino /usr/local/bin/merino
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/merino"]
