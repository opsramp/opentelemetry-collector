# Build stage
FROM us-docker.pkg.dev/opsramp-registry/base/go-fips:1.27.4 AS builder
WORKDIR /app
COPY . .
RUN cd cmd/otelcorecol && CGO_ENABLED=0 go build -trimpath -o ../../bin/otelcorecol .



# Final image
FROM us-docker.pkg.dev/opsramp-registry/base/chainguard-base-fips:latest
RUN apk upgrade --no-cache libcrypto3 libssl3
COPY --from=builder /app/bin/otelcorecol ./otelcollector
CMD ["./otelcollector"]