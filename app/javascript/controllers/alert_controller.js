// Sélectionnez l'élément d'alerte
var alertElement = document.querySelector('.alert');

// Fonction pour masquer l'alerte
function hideAlert() {
  alertElement.style.display = 'none';
}

// Définir un délai de 2 secondes (2000 millisecondes)
var delay = 2000;

// Masquer l'alerte après le délai spécifié
setTimeout(hideAlert, delay);
