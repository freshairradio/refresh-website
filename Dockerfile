FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs
RUN mkdir /myapp
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

ENV ACTIVE_ADMIN_PATH /admin
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_ENV production
RUN bin/rake assets:precompile

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]