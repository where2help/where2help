#/api/v1/needs.json
angular.module("iamin")
  .service "ApiCalendar", ($http) ->
    class ApiCalendar
      needs: -> $http.get("/api/v1/needs.json").then (res) =>
        @_parse_needs res.data.data

      addNeed: (need) ->
        niceNeed = {}
        niceNeed.attributes = {
          'start-time': need.start
          'end-time': need.end
        }
        niceNeed.type = "needs"
        # need['start-time'] = need.start
        # need['end-time'] = need.end#.format()
        $http({
          url: "/api/v1/needs.json",
          dataType: "json",
          method: "POST",
          headers: {
              "Content-Type": "application/vnd.api+json"
          }
          data: {'data': niceNeed}
        })

      updateNeed: (need) ->
        niceNeed =
          id: need.id
        niceNeed.attributes = {
          'start-time': need.start
          'end-time': need.end
        }
        niceNeed.type = "needs"
        # need['start-time'] = need.start
        # need['end-time'] = need.end#.format()
        $http({
          url: "/api/v1/needs/" + niceNeed.id + '.json'
          dataType: "json",
          method: "PUT",
          headers: {
              "Content-Type": "application/vnd.api+json"
          }
          data: {'data': niceNeed}
        })

      deleteNeed: (need) ->
        # niceNeed =
        #   id: need.id
        # niceNeed.attributes = {
        #   'start-time': need.start
        #   'end-time': need.end
        # }
        # niceNeed.type = "needs"
        # need['start-time'] = need.start
        # need['end-time'] = need.end#.format()
        $http({
          url: "/api/v1/needs/" + need.id + '.json'
          dataType: "json",
          method: "DELETE",
          headers: {
              "Content-Type": "application/vnd.api+json"
          }
          data: {'data': niceNeed}
        })

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
        need.title = "#{need.volunteersNeeded} #{need.category}"
        if need.volunteersNeeded == 1
          need.title += " volunteer"
        else
          need.title += " volunteers"
        if need.location
          need.title += " at #{need.location}, #{need.city}."
        else
          need.title += ". (no location)"

        need
    new ApiCalendar
