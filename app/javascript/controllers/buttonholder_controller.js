import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="buttonholder"
export default class extends Controller {
   static targets = ["button", "hidden", "fill"]

  connect() {
    this.timer = null
    this.holdDuration = 1000
    this.startTime = 0
    this.animationFrame = null
  }

  startHold(event) {
    event.preventDefault()
    this.startTime = performance.now()

    const updateFill = (time) => {
      const elapsed = time - this.startTime
      const percent = Math.min((elapsed / this.holdDuration) * 100, 100)
      this.fillTarget.style.width = percent + "%"

      if (percent < 100) {
        this.animationFrame = requestAnimationFrame(updateFill)
      } else {
        this.triggerAction()
      }
    }

    this.animationFrame = requestAnimationFrame(updateFill)
  }

  cancelHold() {
    if (this.animationFrame) {
      cancelAnimationFrame(this.animationFrame)
      this.animationFrame = null
    }
    this.fillTarget.style.width = "0%"
  }

  triggerAction() {
    this.hiddenTarget.value = true
    this.hiddenTarget.form.requestSubmit()
    this.buttonTarget.disabled = true
  }
}
