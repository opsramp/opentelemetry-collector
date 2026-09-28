# Build stage
FROM us-docker.pkg.dev/opsramp-registry/base/golang:1.26.6-alpine3.24 AS builder
WORKDIR /app
COPY . .
RUN cd cmd/otelcorecol && CGO_ENABLED=0 go build -trimpath -o ../../bin/otelcorecol .



# Final image
FROM us-docker.pkg.dev/opsramp-registry/base/alpine:3.24.1
RUN apk upgrade --no-cache libcrypto3 libssl3
COPY --from=builder /app/bin/otelcorecol ./otelcollector
CMD ["./otelcollector"]