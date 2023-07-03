import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"; // You need to import this to use new flatpickr()

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      altInput: true,
      minDate: "today",
      altFormat: "F j, Y at h:i K",
      dateFormat: "Y-m-d H:i",
    })

  }
}
