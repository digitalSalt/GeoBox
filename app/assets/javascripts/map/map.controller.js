(function(){

'use strict';

angular.module('GeoBox')
.controller('MapController', MapController);

MapController.$inject = ['DocumentService', '$scope', '$interval'];
function MapController(DocumentService, $scope, $interval){
	var $ctrl = this;
	$ctrl.doc_markers = [];
	$ctrl.user_marker = [];

	$ctrl.$onInit = function(){
      var hours = (new Date()).getHours();
      var mapStyle;

      if (hours > 6 && hours < 20) {
        mapStyle = 'assets/retroMode.js';
      } else {
        mapStyle = 'assets/nightMode.js';
      }

      $ctrl.handler = Gmaps.build('Google');

      $.get(mapStyle, function(data){
          if (data) {
              var style = JSON.parse(data);
              $ctrl.handler.buildMap({ internal: {id: 'geolocation'}, provider:{
                  zoom: 19,
                  styles: style,
                  heading: 90,
                  streetViewControl: false,
                  fullscreenControl: false
              }}, updateLocation);
          }
      });
	};

	$scope.$on('documents:ready', updateMarkers);

	$ctrl.locUpdater = $interval(function(){
		if ($ctrl.handler){		
			updateLocation();
		}
	}, 7500); // currently updates every 7.5 seconds

	$ctrl.$onDestroy = function(){
		$interval.cancel($ctrl.locUpdater);
	};

	function updateLocation(){
		if(navigator.geolocation) {
	        navigator.geolocation.getCurrentPosition(displayMapCallback);
		}
	}

	function updateMarkers(e,data){
		$ctrl.doc_markers = [];
		DocumentService.docs.forEach(function(doc){
			var new_marker = $ctrl.handler.addMarker({
				lat: Number(doc.latitude),
				lng: Number(doc.longitude),
				picture: {
					url: 'assets/file.png',
					width: 45,
					height: 45
				},
				infowindow: doc.description
			});
			$ctrl.doc_markers.push(new_marker);
		});
	}

	function displayMapCallback(position){
		if (shouldUpdate(position.coords)){
			$ctrl.user_location = position.coords;
			$ctrl.handler.removeMarkers($ctrl.doc_markers.concat($ctrl.user_marker));
			$ctrl.user_marker = $ctrl.handler.addMarker({
	            lat: position.coords.latitude,
	            lng: position.coords.longitude,
	            picture: {
	            	url: 'assets/user.png', 
	            	width: 60, 
	            	height: 60
	            }
	        });

	        $ctrl.handler.map.centerOn($ctrl.user_marker);
			DocumentService.updateLocation(position.coords.latitude.toString(), position.coords.longitude.toString());
		}
  	}

  	function shouldUpdate(coordinates){
		if (!$ctrl.user_location) // should update when first rendering map.
			return true;
		else {
			let distance = google.maps.geometry.spherical.computeDistanceBetween(
				new google.maps.LatLng(coordinates.latitude, coordinates.longitude),
				new google.maps.LatLng($ctrl.user_location.latitude, $ctrl.user_location.longitude)
			);
			return distance > 20; // magikle
		}
	}
}

})();
