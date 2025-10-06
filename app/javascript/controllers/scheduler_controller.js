import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scheduler"
export default class extends Controller {
  static targets = [ "details", "day"]
  connect() {
  }


  showDetails(event) {
    const clickedDate = event.currentTarget
    this.dayTargets.forEach(day => day.parentElement.classList.remove("highlight"))
    clickedDate.parentElement.classList.add("highlight")

    fetch(`/schedules/by_date?date=${encodeURIComponent(clickedDate.dataset.schedulerDate)}`, {
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
