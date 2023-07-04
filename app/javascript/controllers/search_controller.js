import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  search(event) {
    event.preventDefault();

    const button = event.target;
    const gameName = button.getAttribute('data-game-name');
    const form = document.querySelector('.search-form');
    const searchField = form.querySelector('[name="search_query"]');
    searchField.value = gameName;
    form.submit();
  }
}
