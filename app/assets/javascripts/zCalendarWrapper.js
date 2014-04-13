/* ===================================================
 * Basé sur
 * zCalendarWrapper.js v0.2.0
 * https://github.com/evolic/zf2-tutorial/blob/calendar/public/js/evl-calendar/zCalendarWrapper.js
 * ===================================================
 * Copyright 2013 Tomasz Kuter
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */

/**
 * jQuery Fullcalendar wrapper class
 * 
 * Class based on the JavaScript OOP example available at:
 * http://phrogz.net/JS/classes/OOPinJS.html
 * 
 * @author Tomasz Kuter <evolic_at_interia_dot_pl>
 * @version v0.2.0
 * @param {Array} config
 */

function zCalendarWrapper(config) {
    this.constructor.population++;

    // ************************************************************************ 
    // PRIVATE VARIABLES AND FUNCTIONS 
    // ONLY PRIVELEGED METHODS MAY VIEW/EDIT/INVOKE 
    // *********************************************************************** 

    /**
     * jQuery FullCalendar container e.g. '#calendar'
     * @private
     */
    var container = config.container;
    delete config.container;

    /**
     * List of urls used to get/update/delete event(s)
     * For example:
     * {
     *   get: '/events/get',
     *   add: '/events/add',
     *   update: '/events/update',
     *   erase: '/events/delete'
     * }
     * @private
     */
    var api = config.api;
    delete config.api;

    var locales = config.locales;
    delete config.locales;

    /**
     * @private
     */
    var defaults = {
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        defaultView: 'agendaWeek',
        editable: false,
        selectable: true,
        selectHelper: true,
        firstDay: 1, // start week from Monday
        root: 'events',
        success: 'success',
        events: api.get,
        timeFormat: 'H:mm', // uppercase H for 24-hour clock
        axisFormat: 'H:mm',
        slotMinutes: 15,
        snapMinutes: 15,
        defaultEventMinutes: 60,
        select: function( startDate, endDate, allDay, jsEvent, view ) {
            createEvent( startDate, endDate, allDay, jsEvent, view );
        },
        eventClick: function( event, jsEvent, view ) {
            clickEvent( event );
        },
        loading: function(bool) {
            if (bool) $('#loading').show();
            else $('#loading').hide();
        }
    };

    /**
     * @private
     */
    var cfg = defaults;
    $.extend(true, cfg, config);

	var group_id = config.group_id;

    /**
     * @private
     */
    var format = "dd-MM-yyyy HH:mm:ss";
    /**
     * jQuery FullCalendar instance
     * @private
     */
    var calendar = $(container).fullCalendar(cfg);

    /**
     * @private
     */
    function createEvent( startDate, endDate, allDay, jsEvent, view ) {
        var ts = new Date().getTime();

        bootbox.confirm('<form role="form">\
  <div class="form-group" id="input">\
    <label for="eventName">Event Name</label>\
    <input type="text" class="form-control" id="eventName" placeholder="Enter event name">\
  </div>\
  <div class="form-group">\
    <label for="eventLocation">Location</label>\
    <input type="text" class="form-control" id="eventLocation" placeholder="Rue des pythons 9, Sion">\
  </div>\
</form>', function(confirm) {
	
			title = $('input#eventName').val();
			location_name = $('input#eventLocation').val();
            if (confirm && title && location_name) {
                startDate = $.fullCalendar.formatDate(startDate, format);
                endDate = $.fullCalendar.formatDate(endDate, format);

                $.ajax({
                    url: api.add,
                    data: {
                    	event: {
	                        name: title,
	                        startDate: startDate,
	                        endDate: endDate,
	                        group_id: group_id,
	                        location: location_name
	                       }
                    },
                    type: "POST",
                    success: function( response ) {
                            var events = calendar.fullCalendar('clientEvents');
                            for (var i in events) {
                                if (typeof(events[i].ts) !== 'undefined' && events[i].ts == response.ts) {
                                    events[i].id = parseInt(response.id);
                                    delete events[i].ts;
                                }
                            }
		                calendar.fullCalendar('renderEvent', {
		                    title: title,
		                    start: response.startDate,
		                    end: response.endDate,
		                    allDay: false,
		                    ts:ts,
		                    id:response.id
		                }, true); // make the event "stick"
		                console.log(startDate,endDate);
                            
                    },
                    error: function( jqXHR, textStatus, errorThrown ) {
                        bootbox.alert('Error occured during saving event in the database\n'+errorThrown, function() {});
                    }
                });
            }
        });
        calendar.fullCalendar('unselect');
    }

    /**
     * @private
     */
    function updateEvent( event, revertFunc, skipConfirm, report ) {
        var ts = new Date().getTime();
        event.ts = ts;

        if (typeof(skipConfirm) === 'undefined') {
            skipConfirm = false;
        }
        if (typeof(report) === 'undefined') {
            report = false;
        }

        bootbox.confirm(translate('Is this okay?'), translate('Cancel'), translate('OK'), function (result) {
            if (!skipConfirm && !result) {
                revertFunc();
            } else {
                $.ajax({
                    url: api.update,
                    data: {
                        id: event.id,
                        title: event.title,
                        start: event.start.getTimestamp(),
                        end: event.end.getTimestamp(),
                        all_day: event.allDay,
                        ts: ts
                    },
                    type: "POST",
                    success: function( response ) {
                        if (response.success) {
                            bootbox.alert(response.message, function() {});
                            var events = calendar.fullCalendar('clientEvents');

                            for (var i in events) {
                                if (typeof(events[i].ts) !== 'undefined' && events[i].ts == response.ts) {
                                    delete events[i].ts;

                                    if (report) {
                                        // Reports changes to an event and renders them on the calendar
                                        calendar.fullCalendar('updateEvent', events[i]);
                                    }
                                }
                            }
                        } else {
                            bootbox.alert(response.message, function() {});
                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown ) {
                        bootbox.alert('Error occured during saving event in the database', function() {});
                    }
                });
            }
        });
    }

    /**
     * @param {Array} event
     * @private
     */
    function deleteEvent ( event ) {
        var ts = new Date().getTime();
        event.ts = ts;

        $.ajax({
            url: api.erase + "/" + event.id + ".json",
            data: {
                id: event.id,
                ts: ts
            },
            type: "DELETE",
            success: function( response ) {
                    bootbox.alert('Event '+ event.id+ ' deleted!', function() {});
                    var events = calendar.fullCalendar('clientEvents');

                    calendar.fullCalendar("removeEvents", event.id);
            },
            error: function( jqXHR, textStatus, errorThrown ) {
                bootbox.alert('Error occured during deleting event in the database', function() {});
            }
        });
    }


    /**
     * @param {Array} event
     * @private
     */
    function clickEvent ( event ) {
        if (isAdmin) {
        	bootbox.dialog({
		  message: "What do you want to do?",
		  title: "Event",
		  buttons: {
		    danger: {
		      label: "Delete this event",
		      className: "btn-danger",
		      callback: function() {
		        deleteEvent(event);
		      }
		    }
		  }
		});
		}
    }

    /**
     * @private
     */
    function translate(text) {
            return text;
        
    }
    function isOverlapping(event){
	    var array = calendar.fullCalendar('clientEvents');
	    for(i in array){
	        if(!(array[i].start >= event.end || array[i].end <= event.start)){
	            return true;
	        }
	    }
    	return false;
    }
    // ************************************************************************ 
    // PRIVILEGED METHODS 
    // MAY BE INVOKED PUBLICLY AND MAY ACCESS PRIVATE ITEMS 
    // MAY NOT BE CHANGED; MAY BE REPLACED WITH PUBLIC FLAVORS 
    // ************************************************************************ 

    /**
     * @public
     */
    this.getCalendar = function () {
        return calendar;
    };

    // ************************************************************************ 
    // PUBLIC PROPERTIES -- ANYONE MAY READ/WRITE 
    // ************************************************************************ 

}