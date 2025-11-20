import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="scheduler"
export default class extends Controller {
  static targets = [ "details", "day"]
  connect() {
    const today = new Date().toISOString().split("T")[0] // "2025-10-06"
    this.dayTargets.forEach(day => {
      if (day.dataset.date === today) {
        day.classList.add("today")
      }
    })
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

  showHint(event) {
    const dayEl = event.currentTarget
    const gemba = dayEl.dataset.gembaValue || "Sem gemba definido"


    let content = '';

    gemba.split("|").forEach(
      gembaName => { content += `<div>${gembaName}</div>` }
    );

    document.querySelectorAll('.popover').forEach(pop => pop.remove())

    const popover = new window.bootstrap.Popover(dayEl, {
      content: content,
      html: true,
      placement: "top",
      trigger: "manual"
    })

    popover.show()
    setTimeout(() => popover.hide(), 1500)
  }
}
