import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-index"
export default class extends Controller {
  static targets = [ "arrowLeft", "arrowRight", "list", "card0", "card1" ]

  static scrollingPosition = 0;

  connect() {
    this.card1Target.classList.add("low-opacity");
  }

  scrollNext() {
    this.listTarget.classList.remove("scrollLeft");
    this.listTarget.classList.add("scrollRight");
    this.arrowLeftTarget.classList.remove("d-none");
    this.arrowRightTarget.classList.add("d-none");
    this.card0Target.classList.remove("fadeIn");
    this.card0Target.classList.add("fadeOut");
    this.card1Target.classList.remove("fadeOut");
    this.card1Target.classList.add("fadeIn");
  }

  scrollPrevious() {
    this.listTarget.classList.remove("scrollRight");
    this.listTarget.classList.add("scrollLeft");
    this.arrowRightTarget.classList.remove("d-none");
    this.arrowLeftTarget.classList.add("d-none");
    this.card0Target.classList.remove("fadeOut");
    this.card0Target.classList.add("fadeIn");
    this.card1Target.classList.remove("fadeIn");
    this.card1Target.classList.add("fadeOut");
  }
}
