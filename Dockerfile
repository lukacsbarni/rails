FROM ruby:2.3.1
MAINTAINER Mister DevOps

ENV HOME /app
# Configure production environment variable
ENV RAILS_ENV=production

# There is defined the HOME environment variable, we can use in the below commands
ADD . $HOME
WORKDIR $HOME

# Firefox doesn't need for production environment
# Deleting apt cache reduces the image size
# Use a single RUN command to minimize the number of layers

#Install Nodejs 8.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

#Install yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
    && apt-get install -y \
        netcat \
        curl \
        nodejs \
        gcc g++ make \
        yarn \
        libmysqlclient-dev \ 
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf \
     /var/lib/apt \
     /var/lib/dpkg \
     /var/lib/cache \
     /var/lib/log


# Use COPY or ADD instead "RUN cp"
COPY database.yml config/database.yml

# app user doesn't exist in ruby docker image, must be created
RUN useradd -ms /bin/bash app

RUN gem install bundler
RUN bundle install --deployment
RUN bundle exec rake assets:precompile

#Change owner
RUN chown -R app:app $HOME

COPY docker-entrypoint.sh /usr/local/bin

# Run the rails application with app user
USER app
ENTRYPOINT ["docker-entrypoint.sh"]

