import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="listing-map"
export default class extends Controller {
  static targets = ["map", "listings"]
  connect() {
    console.log("connected to map controller")
    if(window.google) {
      this.initGoogle();
    }
  }

  initGoogle() {
    console.log("initGoogle")
    const latLong = { lat: 43.6532, lng: -79.3871  }

    let settings = {
      zoom: 12,
      center: latLong,
      mapTypeControl: true,
      mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
      navigationControl: true,
      navigationControlOptions: {style: google.maps.NavigationControlStyle.ZOOM_PAN},
  };

    const map = new google.maps.Map(this.mapTarget, settings)
    this.addPins(map);
  }

  addPins(map) {
  
    Array.from(this.listingsTarget.children).forEach( (listing) => {
      if(listing.dataset.lat) {
        let infowindow = new google.maps.InfoWindow({
          content: listing.dataset.title + " " + "$" + listing.dataset.price
        });
        let mark = new google.maps.Marker( {
          position: {
            lat: parseFloat(listing.dataset.lat),
            lng: parseFloat(listing.dataset.lng),
          },
          map,
          title: listing.dataset.title,
        })
        infowindow.open(map, mark)
      }
    })
  }


}
