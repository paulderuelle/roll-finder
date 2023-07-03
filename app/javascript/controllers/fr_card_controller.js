import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fr-card"
export default class extends Controller {
  static targets = ["image"];
  static values = { images: Array };
  currentIndex = 0;

  connect() {
    this.imageTarget.src = this.imagesValue[this.currentIndex];
  }

  change() {
    this.currentIndex = (this.currentIndex + 1) % this.imagesValue.length;
    this.imageTarget.src = this.imagesValue[this.currentIndex];
  }
}
