(function(){

'use strict';

angular.module('GeoBox')
.controller('SidebarController', SidebarController);

SidebarController.$inject = ['$rootScope', 'DocumentService', '$scope', 'UserService'];
function SidebarController($rootScope, DocumentService, $scope, UserService){
	var $ctrl = this;
	$ctrl.docs = [];
	$ctrl.books = [];
    $ctrl.rooms = [];
	$ctrl.user = {};
	$ctrl.base_url = null;

	$ctrl.fuzzySearchString_file = '';
    $ctrl.fuzzySearchString_book = '';
    $ctrl.fuzzySearchString_room = '';

	$ctrl.fuzzySearchList_file = [];
    $ctrl.fuzzySearchList_book = [];
    $ctrl.fuzzySearchList_room = [];

	$ctrl.fuzzySearchOptions = {
		  shouldSort: true,
		  threshold: 0.6,
		  location: 0,
		  distance: 30,
		  maxPatternLength: 32,
		  minMatchCharLength: 1,
		  keys: [
		  	"name",
		    "filename",
		    "description",
		    "username"
		  ]
	};

	$ctrl.fuzzySearchResult_file = [];
    $ctrl.fuzzySearchResult_book = [];
    $ctrl.fuzzySearchResult_room = [];

    $ctrl.geocoder = new google.maps.Geocoder();
    $ctrl.flyAddress = '';
    $ctrl.flewAway = false;

	$ctrl.$onInit = function(){
		$rootScope.$broadcast('login:login', {}); // we can consider adding data to this event
		var sidebar = $('#sidebar').sidebar();
		UserService.getUserInfo();
	};

	$ctrl.getDocs = function(e,d){
		$ctrl.docs = processDocuments(DocumentService.docs);
    	$ctrl.books = processBooks(DocumentService.books);
    	$ctrl.rooms = processRooms(DocumentService.rooms);
	};

	$ctrl.getUser = function(e,d){
		$ctrl.user = processUser(UserService.user);
		$ctrl.base_url = UserService.base_url;
	};

	$ctrl.file_search = function(){
		if ($ctrl.fuzzySearchString_file){
			$ctrl.fuzzySearchResult_file = $ctrl.fuzzySearchList_file.search($ctrl.fuzzySearchString_file);
		} else {
			$ctrl.fuzzySearchResult_file = $ctrl.docs; // all documents.
		}
	};

	$ctrl.book_search = function(){
		if ($ctrl.fuzzySearchString_book){
			$ctrl.fuzzySearchResult_book = $ctrl.fuzzySearchList_book.search($ctrl.fuzzySearchString_book);
		} else {
			$ctrl.fuzzySearchResult_book = $ctrl.books; // all books.
		}
	};

	$ctrl.room_search = function(){
		if ($ctrl.fuzzySearchString_room){
			$ctrl.fuzzySearchResult_room = $ctrl.fuzzySearchList_room.search($ctrl.fuzzySearchString_room);
		} else {
			$ctrl.fuzzySearchResult_room = $ctrl.rooms; // all rooms.
		}
	}

	$ctrl.fly = function(e){
		if (e.keyCode == 13){ //enter was pressed
			$ctrl.geocoder.geocode({
				address: $ctrl.flyAddress
			}, function(result, status){
				if (status == 'OK'){
					let fly_lat = result[0].geometry.location.lat();
					let fly_lng = result[0].geometry.location.lng();
					$rootScope.$broadcast('ready_to:fly', {
						fly_lat: fly_lat,
						fly_lng: fly_lng
					});
					$ctrl.flewAway = true;
				} else {
					console.warn("geocoding failed due to", status); // for dev
					alert("sorry, flying failed due to " +  status.toLowerCase()); // for user
				}
			});
		}
	}

	$ctrl.flyHome = function(){
		$ctrl.flewAway = false;
		$ctrl.flyAddress = '';
		$rootScope.$broadcast('fly:flew_home');
	}

	function processDocuments(documents){
		documents.forEach(function(d){
			d.created_at = moment(new Date(d.created_at_ms * 1000)).fromNow();
		});
		$ctrl.fuzzySearchList_file = new Fuse(documents, $ctrl.fuzzySearchOptions);
		$ctrl.fuzzySearchResult_file = documents;
		return documents;
	}

	function processBooks(books){
		books.forEach(function(b){
			b.created_at = moment(new Date(b.created_at_ms * 1000)).fromNow();
		});
		$ctrl.fuzzySearchList_book = new Fuse(books, $ctrl.fuzzySearchOptions);
		$ctrl.fuzzySearchResult_book = books;
		return books;
	}

	function processRooms(rooms){
		rooms.forEach(function(r){
			r.created_at = moment(new Date(r.created_at_ms * 1000)).fromNow();
		});
		$ctrl.fuzzySearchList_room = new Fuse(rooms, $ctrl.fuzzySearchOptions);
		$ctrl.fuzzySearchResult_room = rooms;
		return rooms;
	}

	function processUser(user){
		if (!user.guest){
			user.created_at = moment(new Date(user.created_at_ms * 1000)).fromNow();
			user.updated_at = moment(new Date(user.updated_at_ms * 1000)).fromNow();
		}
		return user;
	}

    $ctrl.openBook = function(id){
	    DocumentService.fetchFilesInBook(id);
    };


	$ctrl.openDoc = function(doc){
		$rootScope.$broadcast("detail_doc_view:ready", {doc: doc});
	};

	$ctrl.openRoom = function(room){
		$rootScope.$broadcast("chatroom:ready", {room: room});
	}

	$scope.$on('documents:ready', $ctrl.getDocs);
	$scope.$on('user:ready', $ctrl.getUser);
}

})();
