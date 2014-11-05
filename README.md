MessageBus
==========

This is a single-page demo of cool interactive charts using Charts.js and Ruby on Rails.

# How to run

* clone the repo
* run `bundle install`
* run `rake db:migrate db:seed`
* run `rails s`
* navigate to `localhost:3000` in your browser

# Highlights

* single-page app
* single controller
* pretty graphics
* bootstrap

# Issues

* needs refactoring
  * many queries in the controller should be helper methods
  * the JSON data builder is too long and complicated
  * generally dry things out
  * JavaScript needs to become its own jQuery plugin for beauty and simplicity
* needs functionality
  * figure out what mean/trending buttons should be