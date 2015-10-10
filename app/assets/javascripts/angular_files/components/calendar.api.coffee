#/api/v1/needs.json
angular.module("iamin")
  .service "ApiCalendar", ($http) ->
    class ApiCalendar
      needs: -> $http.get("/api/v1/needs.json").then (res) =>
        @_parse_needs res.data.data

      _parse_needs:  (rawNeeds) ->
        (@_parse_need rawNeed for rawNeed in rawNeeds)

      # _toCalendarTime: (serverTime, serverDay) ->
      #   # for some reason, scheduleConfig is not imported, so break DRY for now
      #   serverTime = moment.utc serverTime
      #   defaultDate = moment.utc '1999-12-27'
      #   # mutable, so make a copy (for when we use a const)
      #   t = defaultDate.clone()
      #   # shift to the right moment relative to our defaultDate
      #   t.add serverDay - 1, 'd'
      #   t.add serverTime.hours(), 'h'
      #   t.add serverTime.minutes(), 'm'
      #   t

      _parse_need: (rawNeed) ->
        need =
          'id': rawNeed['id']
          category: rawNeed.attributes.category
          city: rawNeed.attributes.city
          start: moment.utc rawNeed.attributes['start-time']
          end: moment.utc rawNeed.attributes['end-time']
          location: rawNeed.attributes.location
          volunteersNeeded: rawNeed.attributes['volunteers-needed']

        #need.title = need.start.format("H:mm") + " – " + need.end.format("H:mm")
        need.title = "#{need.volunteersNeeded} #{need.category} volunteers at #{need.location}, #{need.city}"

        need
    new ApiCalendar
