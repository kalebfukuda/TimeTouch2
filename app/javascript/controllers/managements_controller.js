import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="managements"
export default class extends Controller {
  connect() {
  }

  updateDetails(event) {
    Turbo.visit(this.element.dataset.url, {
      frame: "managements_details"
    })
  }
}
