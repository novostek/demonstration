import $ from 'jquery';

function initializeAutocomplete(id) {
  var element = document.getElementById(id);
  if (element) {
      var autocomplete = new google.maps.places.Autocomplete(element, { types: ['geocode'], componentRestrictions: {country: 'us'} });
      google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
  }
}

function onPlaceChanged() {
  var place = this.getPlace();

  console.log(place);

  // $("#fulladdress").val(place.formatted_address);

  $("#latitude").val(place.geometry.location.lat());
  $("#longitude").val(place.geometry.location.lng());

  $("label").addClass("active");
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

$(document).ready(function(){
  initializeAutocomplete('location');
});