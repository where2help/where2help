# Where2Help

[![Build Status](https://travis-ci.org/where2help/where2help.svg?branch=master)](https://travis-ci.org/where2help/where2help)
[![Dependency Status](https://gemnasium.com/badges/github.com/where2help/where2help.svg)](https://gemnasium.com/github.com/where2help/where2help)

# Development

## Run the project locally

Install bundled gems

    $ bundle install

Start up postgres (if not already running)

    $ postgres -D /usr/local/var/postgres/

Setup the database

    $ createuser --superuser postgres
    
    $ rails db:setup

Populate database with sample data

    $ rails db:populate

Set up your environmental vars

    $ cp .env.example .env

    # Then edit it to add dummy data or your real config data

Start up rails!

    $ rails server


## Run the chatbot

I prefer to use [ngrok local tunnel](https://ngrok.com/) for this.

Download and install it then run:

    # cmd   protocol  eu/us       port rails is running on
    $ ngrok http      --region=eu 3000

You will see your https:// url in the output. Now take this url (ex. https://f6ca333c.eu.ngrok.io) and add it to your webhook config in your Facebook Messenger App settings with the path `/api/v1/chatbot/facebook`. So in our example you would enter `https://f6ca333c.eu.ngrok.io/api/v1/chatbot/facebook`.

Now, when you send messages to the bot, you will now receive them in your locally running app.

## Run the project in Docker

Make sure you have [Docker](https://www.docker.com/) and Docker-Compose setup and running.

Build the project

    $ docker-compose build

Spin up the containers

    $ docker-compose up

Setup the database

    $ docker-compose run app rails db:setup

Populate database with sample data

    $ docker-compose run app rails db:populate

Restart the server

    $ docker-compose stop
    $ docker-compose up

To run the server as an interactive shell (to use e.g. byebug or pry)

    $ docker-compose run --service-ports app

# Deployment

## Heroku

Set up the following environment variables:

* DATABASE_URL
* SENDGRID_USERNAME
* SENDGRID_PASSWORD
* FQDN
* SECRET_KEY_BASE
* RAILS_ENV
* RAILS_SERVE_STATIC_FILE

## CI

[Travis CI](https://travis-ci.org/) is set up to automatically deploy to [Heroku](https://www.heroku.com):

* the `master` branch is automatically deployed to the staging environment:
https://where2help.herokuapp.com/

* the more stable `fsw` branch deployed by FSW by hand

If you want to skip continuous integration for your commit, add this to your commit message:

    [ci skip]

# Contributing to Where2Help

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch, `master` should always be stable.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it, if possible.
* If you're interested in working on an issue that has been assigned to somebody, we encourage you to get in touch with them first!

## Styleguide

### Ruby / Rails
* for Rails, follow the best practices of the [Rails Style Guide](https://github.com/bbatsov/rails-style-guide)
* for Ruby code in general, follow the best practices of the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)

### Translations
* the application is bilingual: *English* & *German*
* everything visible to end users needs to be translated
  * views
  * ActiveRecord model-names and -attributes
  * error messages
* translation strings are kept in `/config/locales`
* please stick to the naming conventions:
  * model-names and model-attributes go into `active_record.<locale>.yml`
  * view-specific translations go into `views.<locale>.yml`
  * human language defaults go into `defaults.<locale>.yml`
  * if a gem needs a certain amount of translation strings, these go into `<gem_name>.<locale>.yml`
  * anything else *(helpers, etc.)* goes into `<locale>.yml`

### CSS

* use the .scss syntax
* use `@import` over to import styles in `application.css.scss`
* keep to the conventions of the `application.css.scss` manifest:
* the granularity of rules increases top to bottom *(general styles on top, more specific ones last)*
  * global rules go into `base/`
  * page specific styles into `pages/`
  * site-wide used component rules go into `base/components.scss` *(extract a components/ directory if it gets to big)*

## Development Environment

### Sample Data

To set up a development environment, you can run this command:

> Warning, this will drop you database :scream:

`bundle exec rake db:drop db:setup db:populate`

This will:

* drop your database
* re-create it
* load the schema (like running migrations but better)
* run seeds
* run the `lib/tasks/db/populate.task` command to load your database with fake data


On top of a bunch of other Event data and users, you will get:

* A volunteer with the email address `user@example.com` and password of `password`
* An NGO with the email address `ngo@example.com` and password of `password`
* An admin user with the email address `admin@example.com` and password of `password`

### Emails

You can use the gem `letter_opener` which opens your emails in a browser tab instead of just printing emails to the logs by running the app like this:

`ENABLE_LETTER_OPENER=1 bundle exec rails server`

If you run it without the `ENABLE_LETTER_OPENER` it will run as you would normally expect.
