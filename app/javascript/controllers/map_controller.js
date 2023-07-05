import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
// Connects to data-controller="map"
export default class extends Controller {
  static values = { apiKey: String, markers: Array }

  connect() {
     mapboxgl.accessToken = this.apiKeyValue;
    //console.log(this.apiKeyValue);
     this.map = new mapboxgl.Map({
       container: this.element,
       style: "mapbox://styles/baladjinn/cljpgqae700tw01p56onngojt"
     })

     this.#addMarkerToMap();
     this.#fitMapToMarkers();

     this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl }))
  }

  #addMarkerToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
      const customMarker = document.createElement("div");
      customMarker.innerHTML = marker.marker_html;
      const mark = new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker. lat])
        .setPopup(popup)
        .addTo(this.map);

    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    this.map.fitBounds(bounds, { padding: 70, maxZoom:15, duration: 0 });
  }
}

// // Récupérer l'élément de la barre de recherche
// const searchBar = document.getElementById('mapbox-search-bar');

// // Modifier le placeholder
// searchBar.addEventListener('load', () => {
//   const searchInput = document.querySelector('.mapboxgl-ctrl-geocoder input');
//   if (searchInput) {
//     searchInput.placeholder = 'Nouveau placeholder';
//   }
// });
