import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
// Connects to data-controller="map"
export default class extends Controller {
  static values = { apiKey: String, markers: Array }

  connect() {
     mapboxgl.accessToken = this.apiKeyValue;
    //console.log(this.apiKeyValue);
    console.log("coucou");

     this.map = new mapboxgl.Map({
       container: this.element,
       style: "mapbox://styles/mapbox/streets-v10"
     })

     this.#addMarkerToMap();
     this.#fitMapToMarkers();
  }

  #addMarkerToMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker. lat])
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    this.map.fitBounds(bounds, { padding: 70, maxZoom:15, duration: 0 });
  }
}