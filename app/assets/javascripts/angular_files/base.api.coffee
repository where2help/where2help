angular.module('iamin')
  .service 'Api', (ApiCalendar) ->
    class Api
      constructor: ->
        @Calendar   =  ApiCalendar

    new Api
