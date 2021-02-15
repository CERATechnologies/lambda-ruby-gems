FROM ruby:2.7.2-alpine

RUN apk update && apk upgrade && apk add git

