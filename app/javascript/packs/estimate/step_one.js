import $ from 'jquery';

let instances = ''
let instanceModal = ''

function initializeAutocomplete(id) {
  var element = document.getElementById(id);
  if (element) {
    var autocomplete = new google.maps.places.Autocomplete(element, { types: ['geocode'], componentRestrictions: { country: 'us' } });
    google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
  }
}

function onPlaceChanged() {
  var place = this.getPlace();

  console.log(place);

  // $("#fulladdress").val(place.formatted_address);

  $("#estimate_latitude").val(place.geometry.location.lat());
  $("#estimate_longitude").val(place.geometry.location.lng());

  // $("label").addClass("active");
  for (var i in place.address_components) {
    var component = place.address_components[i];

    for (var j in component.types) {  // Some types are ["country", "political"]
      var type_element = document.getElementById(component.types[j]);
      if (type_element) {
        type_element.value = component.long_name;
      }
    }
  }
}
document.addEventListener('DOMContentLoaded', function () {
  var elems = document.getElementById('estimate_sales_person_id');
  var elemsModal = document.getElementById('worker-add-modal');
  var instances = M.FormSelect.init(elems, {});

  instances.el.opt

  console.log(instances)

  instanceModal = M.Modal.init(elemsModal, {})
});

// document.getElementById("estimate_sales_person_id").addEventListener('contentChanged', () => $(this).formSelect())

document.getElementById('new_worker').addEventListener('submit', () => {

  const headers = new Headers({
    "Content-Type": "application/json",
    "Accept": "application/json"
  })
  const fetchConfig = {
    headers
  }

  const worker_name = document.getElementById('worker_name').value

  setTimeout(() => {
    fetch(`/workers?q%5Bname_eq%5D=${worker_name}`, fetchConfig)
      .then((data) => data.json())
      .then((res) => {
        console.log(res)
        // const newOption = $('<option>').attr('value', res[0].id).text(res[0].name)
        const newOption = document.createElement('option')
        newOption.text = res[0].name
        newOption.value = res[0].id

        const workers = document.getElementById('estimate_sales_person_id')
        workers.appendChild(newOption)

        M.FormSelect.init(workers)

        // $("#estimate_sales_person_id").append(newOption)

        // $("#estimate_sales_person_id").trigger('contentChanged')

        instanceModal.close()
        const form = document.getElementById("new_worker")
        form.reset()
      })
  }, 300)
})

$(document).ready(function () {
  initializeAutocomplete('estimate_location');
});