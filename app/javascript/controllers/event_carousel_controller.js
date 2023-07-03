import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-index"
export default class extends Controller {
  static targets = [ "arrowLeft", "arrowRight", "card" ]

  static scrollingPosition;

  connect() {
    console.log("yeah");
    this.scrollingPosition = 2;
  }

  scrollNext() {
    for (let index = 0; index < 5; index++) {
      // pick the 4 elements to animate
      const element = this.cardTargets[(this.scrollingPosition + index - 1) % this.cardTargets.length];
      this.#resetPosition(element);
      // add the css classes to animate the element
      element.classList.add(`card${(index + 1) % this.cardTargets.length}`);
      element.classList.add(`switch-to-${index % this.cardTargets.length}`);
    }
    this.scrollingPosition += 1;
  }

  scrollPrevious() {
    for (let index = 0; index < 5; index++) {
      // pick the 4 elements to animate
      const element = this.cardTargets[this.#negMod(this.scrollingPosition + index - 2)];
      this.#resetPosition(element);
      // add the css classes to animate the element
      element.classList.add(`card${(index) % this.cardTargets.length}`);
      element.classList.add(`switch-to-${(index + 1) % this.cardTargets.length}`);
    }
    if (this.scrollingPosition > 0) {
      this.scrollingPosition -= 1;
    } else {
      this.scrollingPosition = this.cardTargets.length - 1;
    }
  }

  #negMod(number) {
    // hack to use the modulo on negatives values
    if (number % this.cardTargets.length < 0) {
      return number % this.cardTargets.length + this.cardTargets.length;
    } else {
      return number % this.cardTargets.length;
    }
  }

  #resetPosition(element) {
    for (let i = 0; i < 5; i++) {
      element.classList.remove(`card${i}`);
      element.classList.remove(`switch-to-${i}`);
    }
  }
}
