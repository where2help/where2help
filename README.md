# Where2Help

[![Build Status](https://travis-ci.org/where2help/where2help.svg?branch=master)](https://travis-ci.org/where2help/where2help)

# Development

Install bundled gems

    $ bundle install

Setup the database

    $ rails db:setup

Populate database with sample data

    $ rails db:populate

Set up the following environment variables:

* DATABASE_URL
* WHERE2HELP_DATABASE_PASSWORD
* SENDGRID_USERNAME
* SENDGRID_PASSWORD
* FQDN
* SECRET_KEY_BASE
* RAILS_ENV
* DATABASE_URL          
* LANG                  
* RACK_ENV              
* RAILS_SERVE_STATIC_FILE

Start up rails!

    $ rails server
