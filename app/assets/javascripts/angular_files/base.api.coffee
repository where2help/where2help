angular.module('where2help')
  .service('Api', ['ApiCalendar', (ApiCalendar) ->
    class Api
      constructor: ->
        @Calendar   =  ApiCalendar

    new Api
  ])
