FROM ruby:2.7.3
COPY . /root
WORKDIR /root

RUN bundle install

ENTRYPOINT bash
