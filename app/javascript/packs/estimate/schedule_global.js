import { Calendar } from "@fullcalendar/core";
import interactionPlugin, { Draggable } from "@fullcalendar/interaction";
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import $ from 'jquery'





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
	$('#external-events .fc-event').mousemove(function () {
		colorData = $(this).data('color');
	})


	const events = window.schedules.map(schedule => ({
		id: schedule.worker_id,
		extendedProps: {
			schedule_id: schedule.id,
			origin: schedule.origin,
			origin_id: schedule.origin_id
		},
		title: schedule.title,
		start: schedule.start_at,
		color: schedule.color,
		end: schedule.end_at,


	}))

	var calendar = new Calendar(calendarEl, {
		header: {
			left: 'prev,next today',
			center: 'title',
			right: "dayGridMonth,timeGridWeek,timeGridDay"
		},
		editable: false,
		plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
		droppable: true, // this allows things to be dropped onto the calendar
		defaultDate: new Date(),
		defaultView: 'timeGridWeek',
		events,
		eventReceive: function ({event,...info}) {
			const { estimate } = window

			const data = {
				title: event.title,
				category: estimate.category,
				description: estimate.description,
				worker_id: event.id,
				color: event.backgroundColor,
				start_at: event.start,
				end_at: event.end,
				origin: event.origin,
				origin_id: event.origin_id
			}


			console.log(event)
			if (checkbox.checked) {
				// if so, remove the element from the "Draggable Events" list
				info.draggedEl.parentNode.removeChild(info.draggedEl);
			}
		},
		eventClick: function(info) {
			//alert('Event: ' + info.event.extendedProps.origin );


			// change the border color just for fun
			info.el.style.borderColor = 'red';

			//window.location = "/schedules/redirect_schedule?origin="+info.event.extendedProps.origin+"&origin_id="+info.event.extendedProps.origin_id;
			$.get( "/workers/load_notes.js?schedule="+info.event.extendedProps.schedule_id, function( data ) {
			});
		}

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