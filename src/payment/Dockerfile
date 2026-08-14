############################
# Dependencies stage
############################
FROM node:22-bookworm-slim AS deps

WORKDIR /app

COPY ./src/payment/package.json package.json
COPY ./src/payment/package-lock.json package-lock.json

RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev \
    && npm cache clean --force


############################
# Runtime stage
############################
FROM gcr.io/distroless/nodejs22-debian12:nonroot

WORKDIR /app

ENV NODE_ENV=production

COPY --from=deps /app/node_modules ./node_modules

COPY ./pb/demo.proto demo.proto

COPY ./src/payment/index.js ./
COPY ./src/payment/charge.js ./
COPY ./src/payment/logger.js ./

CMD [ "index.js"]