'use strict'

angular.module('bopsterApp', [])

  # Setup the application configuration
  .config () ->
    console.debug 'config'

  # Initialize all of the things
  .run () ->
    console.debug 'run'
