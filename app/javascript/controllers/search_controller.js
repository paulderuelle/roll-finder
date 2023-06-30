import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results"]

  connect() {
    console.log("Controller connected");
  }

  search() {
    console.log("Search action");
  }
}
