FROM ruby:3.1.0

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update && apt install --yes --quiet nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install --yes --quiet yarn=1.22.5-1
