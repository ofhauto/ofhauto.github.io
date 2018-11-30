# Use the official Ruby image as the base image
FROM ruby:2.7

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set the working directory
WORKDIR /usr/src/app

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile* ./


# Install Nokogiri and ffi without native extensions
RUN gem install nokogiri -v 1.12.5 --platform=ruby
RUN gem install ffi -v 1.17.1 --platform=ruby

# Install and Bundler
RUN gem install bundler -v 2.1.4
#RUN gem install bundler:1.15.4
RUN gem install jekyll -v 3.2.1


# Install the gems specified in the Gemfile
RUN bundle config set force_ruby_platform true
RUN bundle install

# Copy the rest of the project files into the image
COPY . .

# Expose the port that Jekyll will run on
EXPOSE 4000

# Define the command to build and serve the Jekyll site
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
