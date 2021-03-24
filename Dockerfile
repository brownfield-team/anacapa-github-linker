FROM ruby:2.6.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
&& apt-get update && apt-get install -y nodejs yarn postgresql-client --no-install-recommends \
&& gem install bundler

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock /app/
RUN bundle install
RUN yarn

CMD ["/bin/bash"]