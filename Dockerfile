FROM node:24-alpine AS builder

WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile --allow-build=@nestjs/core --allow-build=unrs-resolver

COPY . .

RUN pnpm build


FROM node:24-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

RUN corepack enable

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile --prod --allow-build=@nestjs/core --allow-build=unrs-resolver

COPY --from=builder /app/dist ./dist

EXPOSE 3000

USER node

CMD ["node", "dist/main"]
