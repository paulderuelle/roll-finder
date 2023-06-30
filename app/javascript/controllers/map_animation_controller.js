import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map-animation"
export default class extends Controller {
  static targets = [ "wrapper", "map", "button" ];
  static mapOpened;

  connect() {
    this.mapOpened = false;
  }

  toggleMap() {
    if (this.mapOpened) {
      this.closeMap()
    } else {
      this.openMap()
    }
  }

  openMap() {
    this.mapOpened = true;
    this.wrapperTarget.classList.remove("slideOut");
    this.mapTarget.classList.remove("fadeOut");
    this.buttonTarget.classList.remove("slideUp");
    this.wrapperTarget.classList.add("slideIn");
    this.mapTarget.classList.add("fadeIn");
    this.buttonTarget.classList.add("slideDown");
    this.buttonTarget.innerHTML = "Show events <i class='fa-solid fa-chevron-up'></i>";
  }

  closeMap() {
    this.mapOpened = false;
    this.wrapperTarget.classList.remove("slideIn");
    this.mapTarget.classList.remove("fadeIn");
    this.buttonTarget.classList.remove("slideDown");
    this.wrapperTarget.classList.add("slideOut");
    this.mapTarget.classList.add("fadeOut");
    this.buttonTarget.classList.add("slideUp");
    this.buttonTarget.innerHTML = "Show the map <i class='fa-solid fa-chevron-down'></i>";
  }
}
