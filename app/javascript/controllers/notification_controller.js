import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  select() {
    const date = this.element.dataset.notificationDate
    const gembaId = this.element.dataset.notificationGembaId
    // dispara evento global
    window.dispatchEvent(new CustomEvent("notification:selected", {
      detail: { date, gembaId }
    }))
  }
}
