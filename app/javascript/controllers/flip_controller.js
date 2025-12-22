import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flip"
export default class extends Controller {
  static targets = ["inner"]

  connect() {
    this.element.addEventListener("click", () => {
      this.element.classList.toggle("is-flipped")
    })
  }
}
