FROM ruby:2.7.4-alpine3.13

RUN apk update && apk upgrade && apk add --no-cache tzdata mysql-dev mysql-client libxml2 libxslt imagemagick openssh sqlite git less curl bash diffutils shared-mime-info
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo Asia/Tokyo > /etc/timezone

RUN rm -rf /var/cache/apk/*


RUN mkdir /app
WORKDIR /app

# install gems
ADD Gemfile /app/Gemfile

RUN apk add --no-cache --virtual .ruby-builddeps alpine-sdk linux-headers libxml2-dev libxslt-dev imagemagick-dev sqlite-dev curl-dev shared-mime-info \
 && bundle install --path vendor/bundle --without development test deployment -j4 \
 && apk del .ruby-builddeps
