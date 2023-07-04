import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review"
export default class extends Controller {
  connect() {
    const detail = document.querySelector(".reviews-details")
    const profile = document.querySelector(".profile-stats")
    const description = document.querySelector(".user-profile-description")
    const review = document.querySelector(".review-stats")
    detail.addEventListener("click",(event) => {
      profile.classList.toggle("d-none")
      description.classList.toggle("d-none")
      review.classList.toggle("d-none")
    })
  }
}
