ARG PHP_VERSION=7.4

FROM ubuntu:18.04

FROM php:${PHP_VERSION}-apache-stretch
FROM php:${PHP_VERSION}-fpm-alpine
FROM node:lts-alpine as frontend

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data

# ------------------------------------------------------------------------------

USER 1000:1000

RUN apt-get -y update

# ------------------------------------------------------------------------------
ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm-alpine

# FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic
# FROM ghcr.io/linuxserver/baseimage-ubuntu:arm64v8-bionic
# FROM ubuntu:latest

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data

# ------------------------------------------------------------------------------

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  git \
  wget \
  curl


RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# ------------------------------------------------------------------------------
