angular.module('iamin')
  #.directive 'calendar', ($compile, $state, $interval, $timeout, Api, calendarConfig) ->
  .directive 'calendar', ($compile, $location, Api) ->
    templateUrl: "/views/directives/calendar.html"
    restrict: 'A'
    link: (scope, element, attrs) ->
      scope.needs = []

      scope.fetch = ->
        console.debug 'fetch needs'
        Api.Calendar.needs().then (needs) ->
          console.debug('got needs ', needs)
          # we got the needs
          scope.needs = needs
          # $('#calendar').fullCalendar 'removeEvents'
          # # tell the calendar to call events to read needs and rerender them
          $('#calendar').fullCalendar 'refetchEvents'

      # navigate away
      # scope.navigateToPlaylistPreview = ->
      #   name  = $state.current.name
      #   destState = "#{name}.preview"
      #   console.debug "destState", destState
      #   $state.go destState

      $(document).ready ->
        $('#calendar').fullCalendar
          #header: true
          header:
            left: 'today prev,next',
            center: 'title',
            right: 'agendaDay,agendaWeek,month'
          #columnFormat: 'ddd'
          allDaySlot: true
          defaultView: 'agendaWeek'
          firstDay: 1
          #timezone: 'UTC'
          timezone: 'local'
          #defaultDate: calendarConfig.defaultDate
          selectable: true
          selectHelper: true
          selectOverlap: true

          select: (start, end) ->
            console.debug 'create', start, end
            $('#calendar').fullCalendar 'unselect'
            #title = 'new need'
            newNeed = undefined
            newNeed =
              #title: title
              #isLoading: true
              start: start
              end: end
            $('#calendar').fullCalendar 'renderEvent', newNeed, false
            # notify the API
            Api.Calendar.addNeed(newNeed).then (need) =>
              # only one of these should be necessary when watching is fixed
              scope.needs.push need
              scope.fetch()
          eventResize: (need, delta, revertFunc) ->
            Api.Calendar.updateNeed(need).then (need) ->
              scope.fetch()
              # TODO: update needs with the new block without fetch?
          eventDrop: (need, delta, revertFunc) ->
            Api.Calendar.updateNeed(need).then (need) ->
              scope.fetch()
          #     # TODO: update needs with the new block without fetch?

          eventClick: (calEvent, jsEvent, view) ->
            window.location.href = '/needs/' + calEvent.id + '/edit'
            #$location.path '/needs/1/edit'

          # eventDestroy: (need, element) ->
          #   # remove scope explicitly
          #   angular.element(element).scope().$destroy()
          eventRender: (need, element) ->
            #console.debug 'event rendered'
            # # add the data into the scope
            # needScope = scope.$new() # child scope
            # # because fullcalendar does some weird time rendering,
            # # we just copy their hard work
            # if need.title
            #   needScope.title = need.title
            # needScope.isLoading = need.isLoading
            # needScope.timeHtml = element.find('.fc-time')[0].outerHTML
            # needScope.need = need
            # needScope.tags = need.tags
            # needScope.playlists = need.playlists
            # needScope.complete = need.complete
            # # massage the html, add our directive inside it
            # element.find('.fc-content').empty()
            # element.find('.fc-content').append "<div schedule-block></div>"
            #
            # # scope.$apply
            # # bind the thing
            # element = $compile(element)(needScope)
            # return element

          editable: true
          eventOverlap: true
          events: (start, end, timezone, callback) ->
            callback scope.needs

        scope.fetch()
