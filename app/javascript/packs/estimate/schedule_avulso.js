import { Calendar } from "@fullcalendar/core";
import interactionPlugin, { Draggable } from "@fullcalendar/interaction";
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import $ from 'jquery'

function saveSchedule(data, event = undefined){
	const headers = new Headers({
		"Content-Type": "application/json",
		"Accept": "application/json"
	})

	const fetchConfig = {
		headers,
		method: "POST",
		body: JSON.stringify(data)
	}
	return fetch('/schedules', fetchConfig)
	.then(data => data.json())
	.then(res => res)
	.catch(error => console.error(error))

}

function deleteSchedule({estimate_id, schedule_id, ...data}){
	const headers = new Headers({
		"Content-Type": "application/json",
		"Accept": "application/json"
	})

	const fetchConfig = {
		headers,
		method: "DELETE",
		body: JSON.stringify(data)
	}

	fetch('/schedules', fetchConfig)
	.then(data => data.json())
	.then(result => console.log(result))
	.catch(error => console.error(error))
}

document.addEventListener('DOMContentLoaded', function() {
	var calendarEl = document.getElementById('fc-external-drag');
	var containerEl = document.getElementById('external-events');
	var checkbox = document.getElementById('drop-remove');
	
	var colorData;
  $('#external-events .fc-event').each(function () {
    // Different colors for events
    $(this).css({ 'backgroundColor': $(this).data('color'), 'borderColor': $(this).data('color') });
  });
  var colorData;
  var category;
  $('#external-events .fc-event').mousemove(function () {
  	colorData = $(this).data('color');
  	category = $(this).data('category');
  })
  // Draggable event init
	new Draggable(containerEl, {
  	itemSelector: '.fc-event',
  	eventData: function (eventEl) {
  		return { 
				id: eventEl.id,
				title: eventEl.innerText,
				color: colorData,
				category
  		};
  	}
	});
	
	const events = window.schedules.map(schedule => ({
		id: schedule.worker_id,
		extendedProps: {
			schedule_id: schedule.id
		},
		title: schedule.title,
		start: schedule.start_at,
		color: schedule.color,
		end: schedule.end_at
	}))
	
  var calendar = new Calendar(calendarEl, {
  	header: {
  		left: 'prev,next today',
  		center: 'title',
  		right: "dayGridMonth,timeGridWeek,timeGridDay"
  	},
  	editable: true,
  	plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
    droppable: true, // this allows things to be dropped onto the calendar
    defaultDate: new Date(),
		defaultView: 'timeGridWeek',
		eventClick: (info) => {
			console.log(info)
			const data = {
				origin: 'Worker',
				schedule_id: info.event.extendedProps.schedule_id,
				worker_id: info.event.id
			}
			//deleteSchedule(data)
			//info.event.remove()
			$.get( "/schedules/load_notes.js?schedule="+info.event.extendedProps.schedule_id, function( data ) {
			});
		},
    events,
    eventReceive: function ({event,...info}) {
		console.log("checked -",$("#send_mail").prop("checked"));
			const data = {
				title: event.title,
				category: event.category,
				worker_id: event.id,
				color: event.backgroundColor,
				start_at: event.start,
				end_at: event.end,
				send_mail: $("#send_mail").prop("checked"),
			}

			saveSchedule(data).then(({schedule}) => event.setExtendedProp('schedule_id', schedule.id))
			console.log(event)
      if (checkbox.checked) {
        // if so, remove the element from the "Draggable Events" list
        info.draggedEl.parentNode.removeChild(info.draggedEl);
      }
		},
		eventResize: ({event}) => {
			const data = {
				title: event.title,
				color: event.backgroundColor,
				schedule_id: event.extendedProps.schedule_id,
				category: event.category,
				worker_id: event.id,
				start_at: event.start,
				end_at: event.end,
			}

			saveSchedule(data)
		},
		eventDrop: ({event}) => {
  		console.log("checked -",$("#send_mail").prop("checked"));
			const data = {
				title: event.title,
				color: event.backgroundColor,
				schedule_id: event.extendedProps.schedule_id,
				category: event.category,
				worker_id: event.id,
				start_at: event.start,
				end_at: event.end,
				send_mail: $("#send_mail").prop("checked"),
			}

			saveSchedule(data)
		},
  });

	calendar.render();
	
})

// $(document).ready(function () {
  
//   var Draggable = FullCalendarInteraction.Draggable;
//   var containerEl = document.getElementById('external-events');
//   var calendarEl = document.getElementById('fc-external-drag');
//   var checkbox = document.getElementById('drop-remove');

//   // initialize the calendar
//   // -----------------------------------------------------------------
//   var calendar = new Calendar(calendarEl, {
//   	header: {
//   		left: 'prev,next today',
//   		center: 'title',
//   		right: "dayGridMonth,timeGridWeek,timeGridDay"
//   	},
//   	editable: true,
//   	plugins: [timeGridPlugin, dayGridPlugin, interactionPlugin],
//     droppable: true, // this allows things to be dropped onto the calendar
//     defaultDate: '2020-01-01',
//     defaultView: 'timeGridWeek',
//     events: [
//     {
//     	title: 'All Day Event',
//     	start: '2020-01-01',
//     	color: '#009688'
//     },
//     {
//     	title: 'Long Event',
//     	start: '2020-01-07',
//     	end: '2020-01-10',
//     	color: '#4CAF50'
//     },
//     {
//     	id: 999,
//     	title: 'Meeting',
//     	start: '2020-01-09T16:00:00',
//     	color: '#00bcd4'
//     },
//     {
//     	id: 999,
//     	title: 'Happy Hour',
//     	start: '2020-01-16T16:00:00',
//     	color: '#3f51b5'
//     },
//     {
//     	title: 'Conference Meeting',
//     	start: '2020-01-11',
//     	end: '2020-01-13',
//     	color: '#e51c23'
//     },
//     {
//     	title: 'Meeting',
//     	start: '2020-01-12T10:30:00',
//     	end: '2020-01-12T12:30:00',
//     	color: '#00bcd4'
//     },
//     {
//     	title: 'Dinner',
//     	start: '2020-01-12T20:00:00',
//     	color: '#4a148c'
//     },
//     {
//     	title: 'Birthday Party',
//     	start: '2020-01-13T07:00:00',
//     	color: '#ff5722'
//     },
//     {
//     	title: 'Click for Google',
//     	url: 'http://google.com/',
//     	start: '2020-01-28',
//     }
//     ],
//     drop: function (info) {
//       // is the "remove after drop" checkbox checked?
//       if (checkbox.checked) {
//         // if so, remove the element from the "Draggable Events" list
//         info.draggedEl.parentNode.removeChild(info.draggedEl);
//       }
//     }
//   });
//   calendar.render();

//   // initialize the external events
//   // ----------------------------------------------------------------

//   //   var colorData;
//   $('#external-events .fc-event').each(function () {
//     // Different colors for events
//     $(this).css({ 'backgroundColor': $(this).data('color'), 'borderColor': $(this).data('color') });
//   });
//   var colorData;
//   $('#external-events .fc-event').mousemove(function () {
//   	colorData = $(this).data('color');
//   })
//   // Draggable event init
//   new Draggable(containerEl, {
//   	itemSelector: '.fc-event',
//   	eventData: function (eventEl) {
//   		return {
//   			title: eventEl.innerText,
//   			color: colorData
//   		};
//   	}
//   });
// })