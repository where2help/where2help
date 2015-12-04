angular.module('where2help')
  #.directive 'calendar', ($compile, $state, $interval, $timeout, Api, calendarConfig) ->
  .directive('calendar', ['$compile', '$location', 'Api', ($compile, $location, Api) ->
    #templateUrl: "/views/directives/calendar.html"
    template: '<p><div id="calendar"></div></p>'
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
            right: 'agendaDay,agendaWeek,month,basicDay'
          #columnFormat: 'ddd'
          allDaySlot: true
          defaultView: 'agendaWeek'
          firstDay: 1
          #timezone: 'UTC'
          timezone: 'local'
          lang: 'de-at'
          timeFormat: 'HH(:mm)'
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

          eventDrop: (need, delta, revertFunc) ->
            Api.Calendar.updateNeed(need).then (need) ->
              scope.fetch()

          eventClick: (calEvent, jsEvent, view) ->
            window.location.href = '/ngos/needs/' + calEvent.id + '/edit'

          eventRender: (need, element) ->
            if need.fulfilled
              $(element).addClass('need-fulfilled')
            element

          editable: true
          eventOverlap: true
          events: (start, end, timezone, callback) ->
            callback scope.needs

        # some customizations
        $('.fc-basicDay-button').text('Agenda')
        scope.fetch()
  ])
