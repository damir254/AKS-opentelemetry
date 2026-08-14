# syntax=docker/dockerfile:1.8

############################
# Build stage
############################
FROM golang:1.25-bookworm AS builder

WORKDIR /src

# Copy Go module files first for layer caching
COPY ./src/product-catalog/go.mod ./src/product-catalog/go.sum ./

RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY ./src/product-catalog/genproto/oteldemo/ genproto/oteldemo/
COPY ./src/product-catalog/flags/ flags/
COPY ./src/product-catalog/main.go main.go


# Build static binary
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    go build \
      -trimpath \
      -ldflags="-s -w" \
      -o product-catalog \
      .

############################
# Runtime stage
############################
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /

COPY --from=builder /src/product-catalog /product-catalog

USER nonroot:nonroot

ENTRYPOINT ["/product-catalog"]