FROM ruby:3.1-slim

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev curl git

RUN curl -O -fsSL https://download.docker.com/linux/debian/gpg
RUN apt-key add gpg

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y postgresql-client yarn

RUN gem install bundler

COPY . $APP_HOME

RUN bundle install

CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]