import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-index"
export default class extends Controller {
  static targets = [ "arrowLeft", "arrowRight", "card" ]
  static scrollingPosition;

  connect() {
    this.scrollingPosition = 2;
    this.initializePositions();
  }

  initializePositions() {
    console.log("Initializing positions for " + this.cardTargets.length + " cards...");
    if (this.cardTargets.length === 1) {
      this.cardTargets[0].classList.add(`card2`);
    } else if (this.cardTargets.length === 2) {
      this.scrollingPosition = 1;
      this.cardTargets[0].classList.add(`card2`);
      this.cardTargets[1].classList.add(`card3`);
    } else {
      this.cardTargets.forEach((card, index) => {
        if (index < 4) {
          card.classList.add(`card${index + 1}`);
        } else {
          card.classList.add(`card4`);
        }
      })
    }
    this.#updateArrows();
  }
  // ================================================ NEXT CLICK
  scrollNext() {
    if (this.cardTargets.length <= 4) {

      this.cardTargets.forEach((card, index) => {
        this.#resetPosition(card);
        const initPos = index - this.scrollingPosition + 3;
        if (initPos <= 0) {
          card.classList.add(`card0`);
        } else if (initPos > 0 && initPos <= 4) {
          card.classList.add(`card${initPos}`);
          card.classList.add(`switch-to-${initPos - 1}`)
        } else {
          card.classList.add(`card4`);
        }
      })
      this.scrollingPosition += 1;
      this.#updateArrows();

    } else {

      for (let index = 0; index < 5; index++) {
        // pick the 4 elements to animate
        const element = this.cardTargets[(this.scrollingPosition + index - 2) % this.cardTargets.length];
        this.#resetPosition(element);
        // add the css classes to animate the element
        if (index < 4) {
          element.classList.add(`card${(index + 1) % this.cardTargets.length}`);
        } else {
          element.classList.add(`card${4 % this.cardTargets.length}`);
        }

        element.classList.add(`switch-to-${index % this.cardTargets.length}`);
      }
      this.scrollingPosition += 1;
    }
  }
  // ====================================================== PREVIOUS CLICK
  scrollPrevious() {
     if (this.cardTargets.length <= 4) {

      this.cardTargets.forEach((card, index) => {
        this.#resetPosition(card);
        const initPos = index - this.scrollingPosition + 3;
        if (initPos < 0) {
          card.classList.add("card0");
        } else if (initPos >= 0 && initPos < 4) {
          card.classList.add(`card${initPos}`);
          card.classList.add(`switch-to-${initPos + 1}`)
        } else {
          card.classList.add(`card4`);
        }
      })
      this.scrollingPosition -= 1;
      this.#updateArrows();

    } else {

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
  }

  scrollTo(event) {
    // get the id given by the click on the pin
    const id = event.params.id;
    let position;
    this.cardTargets.forEach((card) => {
      if (card.id === id.toString()) {
        // get the index of the card we want in the targets array
        position = this.cardTargets.indexOf(card) + 1;
      }
    })
    if (position < this.scrollingPosition) {
      this.#setUp(position + 1);
      this.scrollPrevious();
    } else if (position > this.scrollingPosition) {
      this.#setUp(position - 1);
      this.scrollNext();
    }
  }

  #setUp(position) {
    if (this.cardTargets.length > 2) {
      this.cardTargets.forEach((card, index) => {
        this.#resetPosition(card);
        let pos = 3 - position + index;
        if (pos < 0) { pos = 0 }
        else if (pos > 4) { pos = 4 }
        card.classList.add(`card${pos}`);
      })
      this.scrollingPosition = position;
    }
  }

  #updateArrows() {
    if (this.cardTargets.length <= 1) {
      this.arrowLeftTarget.classList.add("d-none");
      this.arrowRightTarget.classList.add("d-none");
    }
    if (this.scrollingPosition === 1) {
      this.arrowLeftTarget.classList.add("d-none");
      this.arrowRightTarget.classList.remove("d-none");
    } else if (this.scrollingPosition > 1 && this.scrollingPosition < this.cardTargets.length) {
      this.arrowLeftTarget.classList.remove("d-none");
      this.arrowRightTarget.classList.remove("d-none");
    } else if (this.scrollingPosition === this.cardTargets.length) {
      this.arrowLeftTarget.classList.remove("d-none");
      this.arrowRightTarget.classList.add("d-none");
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
