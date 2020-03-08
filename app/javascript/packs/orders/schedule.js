import { Calendar } from "@fullcalendar/core";
import interactionPlugin, { Draggable } from "@fullcalendar/interaction";
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import $ from 'jquery'

function saveSchedule(data, event = undefined) {
	const headers = new Headers({
		"Content-Type": "application/json",
		"Accept": "application/json"
	})

	const fetchConfig = {
		headers,
		method: "POST",
		body: JSON.stringify(data)
	}
	return fetch(`/orders/${window.order.id}/create_schedule`, fetchConfig)
		.then(data => data.json())
		.then(res => res)
		.catch(error => console.error(error))

}

function deleteSchedule({ order_id, schedule_id, ...data }) {
	const headers = new Headers({
		"Content-Type": "application/json",
		"Accept": "application/json"
	})

	const fetchConfig = {
		headers,
		method: "DELETE",
		body: JSON.stringify(data)
	}

	fetch(`/orders/${order_id}/schedule/${schedule_id}/delete`, fetchConfig)
		.then(data => data.json())
		.then(result => console.log(result))
		.catch(error => console.error(error))
}

document.addEventListener('DOMContentLoaded', function () {
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
	// Draggable event init
	new Draggable(containerEl, {
		itemSelector: '.fc-event',
		eventData: function (eventEl) {
			return {
				id: eventEl.id,
				title: eventEl.innerText,
				color: colorData
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
			const data = {
				order_id: order.id,
				origin: 'Order',
				schedule_id: info.event.extendedProps.schedule_id,
				worker_id: info.event.id
			}
			deleteSchedule(data)
			info.event.remove()
		},
		events,
		eventReceive: function ({ event, ...info }) {
			const { order } = window

			const data = {
				title: event.title,
				code: order.code,
				status: order.status,
				worker_id: event.id,
				color: event.backgroundColor,
				start_at: event.start,
				end_at: event.end,
			}

			saveSchedule(data).then(({ schedule }) => event.setExtendedProp('schedule_id', schedule.id))
			console.log(event)
			if (checkbox.checked) {
				// if so, remove the element from the "Draggable Events" list
				info.draggedEl.parentNode.removeChild(info.draggedEl);
			}
		},
		eventResize: ({ event }) => {
			const data = {
				title: event.title,
				code: order.code,
				status: order.status,
				worker_id: event.id,
				color: event.backgroundColor,
				start_at: event.start,
				end_at: event.end,
				schedule_id: event.extendedProps.schedule_id,
			}

			saveSchedule(data)
		},
		eventDrop: ({ event }) => {
			const data = {
				title: event.title,
				color: event.backgroundColor,
				schedule_id: event.extendedProps.schedule_id,
				code: order.code,
				status: order.status,
				worker_id: event.id,
				start_at: event.start,
				end_at: event.end,
			}

			saveSchedule(data)
		},
	});

	calendar.render();

})
