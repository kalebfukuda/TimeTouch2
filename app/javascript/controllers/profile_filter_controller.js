import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-filter"
export default class extends Controller {
  static targets = [ "row", "totalDays", "totalDaysTrend", "totalEarned", "totalEarnedTrend", "totalActiveEmployees", "totalActiveEmployeesTrend" ]

  select(event) {
    const selectedRow = event.currentTarget
    const profileId = selectedRow.dataset.profileId

    // Remove highlight de todas as linhas
    this.rowTargets.forEach(row => row.classList.remove("table-active"))

    // Adiciona highlight na linha selecionada
    selectedRow.classList.add("table-active")

    // Faz a requisição para obter os dados do perfil selecionado
    fetch(`/managements/profile_stats?profile_id=${profileId}`, {
      headers: { "Accept": "text/html" }
    })
      .then(response => response.text())
      .then(html => {
        // Atualiza o conteúdo do frame com os dados do perfil
        this.statsTarget.innerHTML = html
      })
      .catch(error => console.error("Erro ao carregar stats do perfil:", error))
  }

  clear() {
    this.rowTargets.forEach(r => r.classList.remove("row-selected"))

    fetch(`/dashboard/stats`, {
      headers: { "Accept": "text/html" }
    })
    .then(r => r.text())
    .then(html => {
      this.statsTarget.innerHTML = html
    })
  }
}
