import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="registerform"
export default class extends Controller {
  static targets = ["date", "gemba", "validation", "customValue"]

  connect() {
    window.addEventListener("notification:selected", this.fillFromNotification)
  }

  disconnect() {
    window.removeEventListener("notification:selected", this.fillFromNotification)
  }

  fillFromNotification = (e) => {
    const { date, gembaId } = e.detail

    if (this.hasDateTarget) this.dateTarget.value = date
    if (this.hasGembaTarget) this.gembaTarget.value = gembaId
    console.log(this.gembaTarget);

  }

  toggleCustomValue(event) {
    this.customValueTarget.classList.toggle("d-none", !event.target.checked)
  }
}
