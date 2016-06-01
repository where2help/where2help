# Where2Help

[![Build Status](https://travis-ci.org/where2help/where2help.svg?branch=master)](https://travis-ci.org/where2help/where2help)
[![Dependency Status](https://gemnasium.com/badges/github.com/where2help/where2help.svg)](https://gemnasium.com/github.com/where2help/where2help)

# Development

Install bundled gems

    $ bundle install

Start up postgres (if not already running)

    $ postgres -D /usr/local/var/postgres/

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
* LANG
* RACK_ENV
* RAILS_SERVE_STATIC_FILE

Start up rails!

    $ rails server

# Deployment

[Travis CI](https://travis-ci.org/) is set up to automatically deploy applications to [Heroku](https://www.heroku.com):

* the `master` branch is automatically deployed to the staging environment:
https://staging-where2help.herokuapp.com/

* the more stable `fsw` branch is automatically deployed to:
https://where2help.herokuapp.com/

If you want to skip continuous integration for your commit, add this to your commit message:

    [ci skip]

# Contributing to Where2Help

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it, if possible.
* If you're interested in working on an issue that has been assigned to somebody, we encourage you to get in touch with them first!

## Styleguide

### CSS

* use the .scss syntax
* use `@import` over to import styles in `application.css.scss`
* keep to the conventions of the `application.css.scss` manifest: the granularity of rules increases top to bottom *(general styles on top, more specific ones last)*
* global rules go into `base/`
* page specific styles into `pages/`
* site-wide used component rules go into `base/components.scss` *(extract a components/ directory if it gets to big)*
