document.addEventListener("DOMContentLoaded", function() {
  // Sélectionnez l'élément du dropdown
  const dropdown = document.querySelector(".navbar-avatar .dropdown-menu");

  // Sélectionnez l'élément du dropdown-toggle
  const dropdownToggle = document.querySelector(".navbar-avatar a.dropdown-toggle");

  // Gérez le clic sur le dropdown-toggle
  dropdownToggle.addEventListener("click", function(e) {
    e.preventDefault();
    dropdown.classList.toggle("show");
  });

  // Gérez la fermeture du dropdown lors du clic en dehors de celui-ci
  document.addEventListener("click", function(event) {
    const targetElement = event.target;
    if (!targetElement.closest(".navbar-avatar")) {
      dropdown.classList.remove("show");
    }
  });
});
