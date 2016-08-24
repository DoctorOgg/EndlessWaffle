http://epigene.github.io/Rails5_Redis_And_Sidekiq/

bundle exec sidekiq -e development
worker: bundle exec sidekiq -c 10 -q priority -q default

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
