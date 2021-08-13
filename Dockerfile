FROM ruby:3.0.2

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
RUN apt update && apt install --yes --quiet nodejs=16.6.2-1nodesource1

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install --yes --quiet yarn=1.22.5-1
