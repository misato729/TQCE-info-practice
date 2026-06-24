FROM ruby:3.4.9

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV BUNDLE_DEPLOYMENT="true" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_ENV="production" \
    RACK_ENV="production"

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.11 \
  && bundle _2.5.11_ install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
