[![Build Status](https://travis-ci.org/Chucheen/Leaderboard.svg?branch=master)](https://travis-ci.org/Chucheen/Leaderboard)
# Synap Weighin - Track and be the best weigh gainer on holidays

## Installation

Leaderboard is a Rails 4.2.10 application.

Dependencies:

* Ruby 2.3.3
* PostgreSQL
* Bundler
* RVM (Not a mandatory one but makes it much easier for a development environment:)

### RVM

To install:

    $ git clone git@github.com:Chucheen/Leaderboard.git
    $ cd Leaderboard

For the purpose of this document we assume that you have installed the latest stable `rvm` (which at the time of writing is `1.29.3`). And we also assume that you have the Ruby version `2.3.3`.

Now, let's create an `.rvmrc` file to store our rvm configuration and re-use it:

    $ rvm use 2.3.3@Leaderboard --create

In the global gemset for the ruby version you are using you should have `bundler`:

    $ gem install bundler

### Finally run:

    $ bundle install
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed
    $ rake checkins:backfill_deltas
    $ rails s

And you should be able to browse to [http://localhost:3000/](http://localhost:3000/) and you should see the application.

## Deploy to production

    git push heroku master

This application has been already deployed to heroku under: https://weight-tracker.herokuapp.com/
