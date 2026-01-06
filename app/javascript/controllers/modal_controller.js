import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.bootstrapModal = new bootstrap.Modal(this.modalTarget)
    this.bootstrapModal.show()
  }

  open() {
    this.bootstrapModal = new bootstrap.Modal(this.modalTarget)
    this.bootstrapModal.show()
  }

  close() {
    this.bootstrapModal.hide()
  }

  confirmRegister() {
    const duplicated_register = document.getElementById("duplicated_register")
    if (duplicated_register) {
      duplicated_register.value = "true"
    }

    this.bootstrapModal.hide()
    duplicated_register.form.requestSubmit()
  }
}
