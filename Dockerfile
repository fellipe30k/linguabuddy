FROM ruby:3.3.0-slim

WORKDIR /app
COPY . /app

# Instalar as gems via bundler
RUN gem install bundler && bundle install

# Comando default: exibir instruções
CMD ["ruby", "word.rb"]
