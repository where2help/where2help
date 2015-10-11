angular.module('iamin')
  .service('Api', ['ApiCalendar', (ApiCalendar) ->
    class Api
      constructor: ->
        @Calendar   =  ApiCalendar

    new Api
  ])
