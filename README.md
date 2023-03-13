# README

Here is a basic implmentation of the app described in the code challenge document. it has the following functionality:
 - a client can CRUD the data
 - a client can mark a course completed
 - Rspec tests for the models and controllers
 - yard documentation for the models and controllers

Gems used:
 - yard
 - factory_bot
 - faker
 - simplecov
 - bullet (for checking n+1 issues)

## Setup
 - Clone into a directory
 - run `bundle install` to install the gems.
 - run `rails db:prepare` to setup the database and seed it with some data.
 - run `rails s` to start the server
 - run `yard server` to start the yard server
