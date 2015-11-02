# where2help

Find the best way to volunteer and help refugees. Start by saying:

> I'm in!

Organisers can create a *need*, set its location, time and the number and type
of volunteers required.

![need calendar](docs/img/needs_calendar.png)

Volunteers can see the needs in a list and join a need by clicking *I'm in*.

![need calendar](docs/img/user_web.png)

This way, volunteers applying for a need are registered (no volunteers will be
turned down on the spot due to too many people showing up) and the
organisers can keep track of those needs that still need more people.

The web app is getting its last fixes and is coming soon, along with an Android
and iOS app at the following URL:

<http://where2help.at>

Initial version of the web and mobile app was built in two days as part of the
[Refugee Hack Vienna](http://www.hackathon.wien/).

## Installation

__ENV Variables for configuration managment__

Your system environmental variables are kept in your `.env` file. There is an example of all of the vars you need in `.env.example`. You can copy this file to `.env` when you start and edit the vars to how you like your system setup.

If you need environment specific (eg. test, development) .env files, [look here](https://github.com/bkeepers/dotenv#multiple-rails-environments)

## Development

Install bundled gems

    $ bundle install

Copy over the environment variables file

    $ cp .env.example .env

Modify the `DATABASE_URL` in .env to reflect this:

    DATABASE_URL='postgres://where2help:where2help@127.0.0.1:5432/where2help_development'

On Linux, create a database role, and database:

    $ sudo -u postgres -i
    % createuser where2help --pwprompt # just use where2help as password in the prompt
    % createdb --owner where2help where2help_development

Setup the database

    $ bundle exec rake db:setup

Migrate and populate the data

    $ bundle exec rake db:migrate
    $ bundle exec rake db:populate

Start up rails!

    $ rails server

### Tests

Add a test env file and change the `DATABASE_URL` to e.g. `where2help_test`

    $ cp .env.sample .env.test

Setup the test db

    $ bundle exec rake db:setup RAILS_ENV='test'

Run specs

    $ rspec spec/


## Contributing

Please see our [contributing guidelines](CONTRIBUTING.md).

## Code of Conduct

Please follow our [code of conduct](code_of_conduct.md).

## License

Where2help is licensed under the [GNU Affero General Public License v3 ](LICENSE.md).
