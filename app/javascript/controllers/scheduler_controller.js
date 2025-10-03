import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scheduler"
export default class extends Controller {
  static targets = [ "details" ]
  connect() {
  }


  showDetails(event) {
    const clickedDate = event.currentTarget.dataset.schedulerDate

     fetch(`/schedules/by_date?date=${encodeURIComponent(clickedDate)}`, {
      headers: { "Accept": "text/html" } // queremos HTML
      })
      .then(response => response.text())
      .then(html => {
        // substitui o conteúdo do container
        this.detailsTarget.innerHTML = html
      })
      .catch(error => console.error("Erro ao carregar schedules:", error))
  }
}
