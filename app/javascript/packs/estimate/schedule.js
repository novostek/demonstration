import { Calendar } from "@fullcalendar/core";
import interactionPlugin from "@fullcalendar/interaction";
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';

document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('fc-external-drag');

  var calendar = new Calendar(calendarEl, {
  	header: {
  		left: 'prev,next today',
  		center: 'title',
  		right: "dayGridMonth,timeGridWeek,timeGridDay"
  	},
  	editable: true,
  	plugins: [timeGridPlugin, dayGridPlugin, interactionPlugin],
    droppable: true, // this allows things to be dropped onto the calendar
    defaultDate: '2020-01-01',
    defaultView: 'timeGridWeek',
    events: [
    {
    	title: 'All Day Event',
    	start: '2020-01-01',
    	color: '#009688'
    },
    {
    	title: 'Long Event',
    	start: '2020-01-07',
    	end: '2020-01-10',
    	color: '#4CAF50'
    },
    {
    	id: 999,
    	title: 'Meeting',
    	start: '2020-01-09T16:00:00',
    	color: '#00bcd4'
    },
    {
    	id: 999,
    	title: 'Happy Hour',
    	start: '2020-01-16T16:00:00',
    	color: '#3f51b5'
    },
    {
    	title: 'Conference Meeting',
    	start: '2020-01-11',
    	end: '2020-01-13',
    	color: '#e51c23'
    },
    {
    	title: 'Meeting',
    	start: '2020-01-12T10:30:00',
    	end: '2020-01-12T12:30:00',
    	color: '#00bcd4'
    },
    {
    	title: 'Dinner',
    	start: '2020-01-12T20:00:00',
    	color: '#4a148c'
    },
    {
    	title: 'Birthday Party',
    	start: '2020-01-13T07:00:00',
    	color: '#ff5722'
    },
    {
    	title: 'Click for Google',
    	url: 'http://google.com/',
    	start: '2020-01-28',
    }
    ],
    drop: function (info) {
      // is the "remove after drop" checkbox checked?
      if (checkbox.checked) {
        // if so, remove the element from the "Draggable Events" list
        info.draggedEl.parentNode.removeChild(info.draggedEl);
      }
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