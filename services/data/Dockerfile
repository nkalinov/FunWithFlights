FROM node:16-alpine as deps
WORKDIR /app

COPY ./.yarn ./.yarn
COPY package.json yarn.lock .yarnrc.yml ./
COPY ./services/data/package.json ./services/data/package.json

RUN yarn install

FROM node:16-alpine as runner
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY .yarn/releases ./.yarn/releases
COPY package.json yarn.lock .yarnrc.yml ./
COPY ./services/data ./service

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:/app/service/node_modules/.bin:$PATH

ENV NODE_ENV production
ENV PORT 3000
EXPOSE $PORT

WORKDIR /app/service
CMD ["node", "dist/main.js"]