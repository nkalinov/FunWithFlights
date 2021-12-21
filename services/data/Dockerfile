FROM node:16-alpine as deps
WORKDIR /app

COPY ./.yarn ./.yarn
COPY package.json yarn.lock .yarnrc.yml ./
COPY ./services/data/package.json ./services/data/

RUN yarn install

FROM node:16-alpine as build
WORKDIR /app

COPY --from=deps /app .
#COPY --from=deps /app/node_modules ./node_modules
COPY ./services/data ./services/data

#ENV PATH /app/node_modules/.bin:/app/services/data/node_modules/.bin:$PATH

WORKDIR /app/services/data
RUN yarn build

FROM node:16-alpine as runner
WORKDIR /app

COPY --from=build /app/services/data/dist ./dist

ENV NODE_ENV production
ENV PORT 3000
EXPOSE $PORT

CMD ["node", "dist/main.js"]